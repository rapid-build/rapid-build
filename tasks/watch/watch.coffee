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
		tCache: require "#{config.req.tasks}/minify/template-cache"
		buildSpa: ->
			gulp.start "#{config.rb.prefix.task}watch-build-spa"
		browserSync: ->
			browserSync.reload stream:false

	# globs
	# =====
	getGlob = (loc, type, lang) ->
		globs = []
		['app'].forEach (v1) ->
			['client', 'server'].forEach (v2) ->
				return if v2 is 'server' and type isnt 'scripts'
				globs.push config.glob[loc][v1][v2][type][lang]
		globs
	glob =
		src:
			coffee: getGlob 'src', 'scripts', 'coffee'
			css:    getGlob 'src', 'styles',  'css'
			es6:    getGlob 'src', 'scripts', 'es6'
			js:     getGlob 'src', 'scripts', 'js'
			less:   getGlob 'src', 'styles',  'less'
			html:   getGlob 'src', 'views',   'html'
			images: getGlob 'src', 'images',  'all'

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
	htmlWatch = ->
		if config.angular.templateCache.dev
			createWatch glob.src.html, 'tCache',
				lang:'html', srcType:'views', taskOnly:true, logTaskName:'template cache'
		else
			createWatch glob.src.html, 'html', lang:'html', srcType:'views', bsReload:true

	# spa watch (if custom spa file then watch it)
	# ============================================
	spaWatch = ->
		if config.spa.custom
			return createWatch config.spa.src.path, 'build spa', lang: config.spa.dist.file
		promiseHelp.get()

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}watch", ->
		defer = q.defer()
		q.all([
			# images
			createWatch glob.src.images,    'image',  lang:'image',  srcType:'images',  bsReload:true
			# styles
			createWatch glob.src.css,       'css',    lang:'css',    srcType:'styles'
			createWatch glob.src.less,      'less',   lang:'less',   srcType:'styles',  extDist:'css'
			# scripts
			createWatch glob.src.coffee[0], 'coffee', lang:'coffee', srcType:'scripts', extDist:'js'
			createWatch glob.src.coffee[1], 'coffee', lang:'coffee', srcType:'scripts', extDist:'js', loc:'server'
			createWatch glob.src.es6[0],    'es6',    lang:'es6',    srcType:'scripts', extDist:'js'
			createWatch glob.src.es6[1],    'es6',    lang:'es6',    srcType:'scripts', extDist:'js', loc:'server'
			createWatch glob.src.js[0],     'js',     lang:'js',     srcType:'scripts'
			createWatch glob.src.js[1],     'js',     lang:'js',     srcType:'scripts', loc:'server'
			# views
			htmlWatch()
			# spa
			spaWatch()
		]).done -> defer.resolve()
		defer.promise


