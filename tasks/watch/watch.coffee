module.exports = (gulp, config, browserSync) ->
	q           = require 'q'
	path        = require 'path'
	gWatch      = require 'gulp-watch'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

	# tasks
	# =====
	tasks =
		clean:  require "#{config.req.tasks}/clean/clean-dist"
		coffee: require "#{config.req.tasks}/compile/coffee"
		css:    require "#{config.req.tasks}/copy/copy-css"
		es6:    require "#{config.req.tasks}/compile/es6"
		html:   require "#{config.req.tasks}/copy/copy-html"
		image:  require "#{config.req.tasks}/copy/copy-images"
		js:     require "#{config.req.tasks}/copy/copy-js"
		less:   require "#{config.req.tasks}/compile/less"
		sass:   require "#{config.req.tasks}/compile/sass"
		tCache: require "#{config.req.tasks}/minify/template-cache"
		buildSpa: ->
			gulp.start "#{config.rb.prefix.task}watch-build-spa"
		browserSync: ->
			return unless config.build.server
			browserSync.reload stream:false

	# helpers
	# =======
	getAppOrRb = (file) ->
		return 'rb' if file.path.indexOf(config.src.rb.dir) isnt -1
		'app'

	getClientOrServer = (file) ->
		return 'client' if file.path
			.indexOf(config.src[file.rbAppOrRb].server.scripts.dir) is -1
		'server'

	getRelative = (file) ->
		dir = path.dirname file.relative
		return '' if dir is '.'
		dir

	getFileName = (file) ->
		fileName = path.basename file.path
		fileName

	getDistDir = (file, opts={}) ->
		dir = config.dist[file.rbAppOrRb][file.rbClientOrServer][opts.srcType].dir
		dir = path.join dir, file.rbRelative
		dir

	getDistPath = (file, opts={}) ->
		fileName = file.rbFileName
		if opts.extDist
			extSrc   = path.extname fileName
			fileName = fileName.replace extSrc, ".#{opts.extDist}"
		dPath = path.join file.rbDistDir, fileName
		dPath

	addFileProps = (file, opts={}) -> # must be in order
		file.rbAppOrRb        = getAppOrRb file
		file.rbClientOrServer = getClientOrServer file
		file.rbRelative       = getRelative file
		file.rbFileName       = getFileName file
		file.rbDistDir        = getDistDir file, opts
		file.rbDistPath       = getDistPath file, opts
		file

	# event tasks
	# ===========
	changeTask = (taskName, file) ->
		tasks[taskName] gulp, config, file

	addAndUnlinkTask = (taskName, file, opts) ->
		return changeTask taskName, file if opts.taskOnly
		tasks[taskName](gulp, config, file).then ->
			return tasks.browserSync() if opts.bsReload
			if taskName is 'clean' and opts.cleanCb
				opts.cleanCb(file).then -> tasks.buildSpa()
			else
				tasks.buildSpa()

	events = (file, taskName, opts={}) -> # add, change, unlink
		log.watch taskName, file, opts
		return tasks.buildSpa() if taskName is 'build spa'
		return if not file
		return if not file.event
		return if not file.path
		return if not taskName
		file = addFileProps file, opts
		unlinkTaskName = if opts.taskOnly then taskName else 'clean'
		switch file.event
			when 'change' then changeTask taskName, file
			when 'unlink' then addAndUnlinkTask unlinkTaskName, file, opts
			when 'add'    then addAndUnlinkTask taskName, file, opts

	# watches
	# =======
	createWatch = (_glob, taskName, opts={}) ->
		defer = q.defer()
		gWatch _glob, read:false, (file) ->
			events file, taskName, opts
		.on 'ready', ->
			loc = opts.loc or 'client'
			msg = if opts.lang.indexOf('.') isnt -1 then 'file' else 'files'
			console.log "watching #{loc} #{opts.lang} #{msg}".yellow
			defer.resolve()
		defer.promise

	# html watch (handle angular template cache)
	# ==========================================
	htmlWatch = (views) ->
		return if config.angular.templateCache.dev
			createWatch views, 'tCache', lang:'html', srcType:'views', taskOnly:true, logTaskName:'template cache'
		createWatch views, 'html', lang:'html', srcType:'views', bsReload:true

	# spa watch (if custom spa file then watch it)
	# ============================================
	spaWatch = (spaFilePath) ->
		return promiseHelp.get() unless config.spa.custom
		createWatch spaFilePath, 'build spa', lang: config.spa.dist.file

	# callbacks
	# =========
	cleanStylesCb = (file) ->
		config.internal.deleteFileImports file.rbAppOrRb, file.rbDistPath
		promiseHelp.get()

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}watch", ->
		defer   = q.defer()
		watches = []

		# client watch: images, styles, scripts, views and the spa.html
		watches = watches.concat [
			-> createWatch config.glob.src.app.client.images.all,     'image',  lang:'image',  srcType:'images',  bsReload:true
			-> createWatch config.glob.src.app.client.styles.css,     'css',    lang:'css',    srcType:'styles',  cleanCb: cleanStylesCb
			-> createWatch config.glob.src.app.client.styles.less,    'less',   lang:'less',   srcType:'styles',  extDist:'css', cleanCb: cleanStylesCb
			-> createWatch config.glob.src.app.client.styles.sass,    'sass',   lang:'sass',   srcType:'styles',  extDist:'css', cleanCb: cleanStylesCb
			-> createWatch config.glob.src.app.client.scripts.coffee, 'coffee', lang:'coffee', srcType:'scripts', extDist:'js'
			-> createWatch config.glob.src.app.client.scripts.es6,    'es6',    lang:'es6',    srcType:'scripts', extDist:'js'
			-> createWatch config.glob.src.app.client.scripts.js,     'js',     lang:'js',     srcType:'scripts'
			-> htmlWatch config.glob.src.app.client.views.html
			-> spaWatch config.spa.src.path
		] if config.build.client

		# server watch: scripts
		watches = watches.concat [
			-> createWatch config.glob.src.app.server.scripts.coffee, 'coffee', lang:'coffee', srcType:'scripts', extDist:'js', loc:'server'
			-> createWatch config.glob.src.app.server.scripts.es6,    'es6',    lang:'es6',    srcType:'scripts', extDist:'js', loc:'server'
			-> createWatch config.glob.src.app.server.scripts.js,     'js',     lang:'js',     srcType:'scripts', loc:'server'
		] if config.build.server

		# async
		promises = watches.map (watch) -> watch()
		q.all(promises).done -> defer.resolve()
		defer.promise


