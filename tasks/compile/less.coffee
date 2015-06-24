module.exports = (gulp, config, watchFile={}) ->
	q            = require 'q'
	path         = require 'path'
	es           = require 'event-stream'
	gulpif       = require 'gulp-if'
	less         = require 'gulp-less'
	plumber      = require 'gulp-plumber'
	lessHelper   = require("#{config.req.helpers}/Less") config, gulp
	forWatchFile = !!watchFile.path

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
	runTask = (src, dest, forWatch, appOrRb) ->
		defer = q.defer()
		gulp.src src
			.pipe plumber()
			.pipe less()
			.pipe gulpif forWatch, addToDistPath appOrRb
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	# less helpers
	# ============
	getImports = (appOrRb) ->
		defer = q.defer()
		new lessHelper config.glob.src[appOrRb].client.styles.less
			.setImports()
			.then (me) ->
				imports = me.getImports()
				defer.resolve imports
		defer.promise

	getWatchSrc = (appOrRb) ->
		defer = q.defer()
		new lessHelper config.glob.src[appOrRb].client.styles.less
			.setImports()
			.then (me) ->
				src  = me.getWatchSrc watchFile.path
				defer.resolve src
		defer.promise

	# less runs
	# =========
	runLessWatch = (appOrRb) ->
		defer = q.defer()
		getWatchSrc(appOrRb).then (src) ->
			dest = config.dist[appOrRb].client.styles.dir
			runTask(src, dest, true, appOrRb).done -> defer.resolve()
		defer.promise

	runLess = (appOrRb) ->
		defer = q.defer()
		getImports(appOrRb).then (imports) ->
			dest = config.dist[appOrRb].client.styles.dir
			src  = config.glob.src[appOrRb].client.styles.less
			src  = [].concat src, imports
			runTask(src, dest).done -> defer.resolve()
		defer.promise

	# entry points
	# ============
	runSingle = ->
		runLessWatch watchFile.rbAppOrRb

	runMulti = ->
		defer = q.defer()
		q.all([
			runLess 'app'
			runLess 'rb'
		]).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	return runSingle() if forWatchFile
	gulp.task "#{config.rb.prefix.task}less", -> runMulti()







