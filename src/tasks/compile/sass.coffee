module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q           = require 'q'
	path        = require 'path'
	es          = require 'event-stream'
	gulpif      = require 'gulp-if'
	plumber     = require 'gulp-plumber'
	sass        = require "#{config.req.plugins}/gulp-sass"
	sassHelper  = require("#{config.req.helpers}/Sass") config, gulp
	taskManager = require("#{config.req.manage}/task-manager") config, gulp
	extCss      = '.css'

	# streams
	# =======
	addToDistPath = (appOrRb) ->
		transform = (file, cb) ->
			fileName    = path.basename file.path
			basePath    = file.base.replace config.src[appOrRb].client.styles.dir, ''
			basePathDup = path.join basePath, basePath
			relPath     = path.join basePathDup, file.relative
			_path       = path.join config.src[appOrRb].client.styles.dir, relPath
			file.path   = _path
			cb null, file
		es.map transform

	# main task
	# =========
	runTask = (src, dest, appOrRb) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe plumber()
			.pipe sass().on 'data', (file) ->
				# needed for empty files. without, ext will stay .scss
				ext = path.extname file.relative
				file.path = file.path.replace ext, extCss if ext isnt extCss
			.pipe gulpif forWatchFile, addToDistPath appOrRb
			.pipe gulp.dest dest
			.on 'data', (file) ->
				return unless forWatchFile
				watchFilePath = path.relative file.cwd, file.path
				taskManager.runWatchTask 'update-css-urls:dev', { watchFilePath }
			.on 'end', ->
				defer.resolve message: "completed: run task"
		defer.promise

	# helpers
	# =======
	getImports = (appOrRb) ->
		defer = q.defer()
		new sassHelper config.glob.src[appOrRb].client.styles.sass
			.setImports()
			.then (me) ->
				imports = me.getImports()
				defer.resolve imports
		defer.promise

	getWatchSrc = (appOrRb) ->
		defer = q.defer()
		new sassHelper config.glob.src[appOrRb].client.styles.sass
			.setImports()
			.then (me) ->
				src = me.getWatchSrc Task.opts.watchFile.path
				defer.resolve src
		defer.promise

	# runs
	# ====
	runWatch = (appOrRb) ->
		tasks = [
			-> getWatchSrc(appOrRb).then (src) ->
				dest = config.dist[appOrRb].client.styles.dir
				targets = { src, dest, appOrRb }
			(targets) ->
				runTask targets.src, targets.dest, targets.appOrRb
		]
		tasks.reduce(q.when, q()).then ->
			message: "completed: run watch"

	init = (appOrRb) ->
		tasks = [
			-> getImports(appOrRb).then (imports) ->
				dest = config.dist[appOrRb].client.styles.dir
				src  = config.glob.src[appOrRb].client.styles.sass
				src  = [].concat src, imports
				targets = { src, dest, appOrRb }
			(targets) ->
				runTask targets.src, targets.dest, targets.appOrRb
		]
		tasks.reduce(q.when, q()).then ->
			message: "completed: init"

	# API
	# ===
	api =
		runSingle: ->
			runWatch Task.opts.watchFile.rbAppOrRb

		runMulti: ->
			q.all([
				init 'app'
				init 'rb'
			]).then ->
				log: true
				message: "compiled sass to: #{config.dist.app.client.dir}"

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()


