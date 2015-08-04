module.exports = (gulp, config, watchFile={}) ->
	q             = require 'q'
	path          = require 'path'
	es            = require 'event-stream'
	gulpif        = require 'gulp-if'
	minifyHtml    = require 'gulp-minify-html'
	templateCache = require 'gulp-angular-templatecache'
	ngFormify     = require "#{config.req.plugins}/gulp-ng-formify"
	runNgFormify  = config.angular.ngFormify
	forWatchFile  = !!watchFile.path

	# globs
	# =====
	getGlob = (loc, type, lang) ->
		config.glob.src[loc].client[type][lang]
	glob =
		views:
			rb:  getGlob 'rb',  'views', 'html'
			app: getGlob 'app', 'views', 'html'

	# helpers
	# =======
	getAppOrRb = (base, loc, type) -> # base = file.base from buffer
		return if not base
		return 'rb' if base.indexOf(config[loc].rb.client[type].dir) isnt -1
		'app'

	getRoot = ->
		useAbsolutePaths = config.angular.templateCache.useAbsolutePaths
		prefix           = config.angular.templateCache.urlPrefix
		prefix           = "/#{prefix}" if useAbsolutePaths and prefix[0] isnt '/'
		prefix

	# streams
	# =======
	addToDistPath = -> # add 'views/' for app and 'rapid-build/views/' for rb
		transform = (file, cb) ->
			appOrRb   = getAppOrRb file.base, 'src', 'views'
			dirName   = config.dist[appOrRb].client.views.dirName
			dirName   = path.join config.rb.prefix.distDir, dirName if appOrRb is 'rb'
			relPath   = path.join dirName, file.relative
			modPath   = path.join file.base, relPath
			file.path = modPath
			cb null, file
		es.map transform

	# tasks
	# =====
	runTask = (src, dest, file, isProd) ->
		defer   = q.defer()
		minify  = isProd and config.minify.html.views
		minOpts = config.minify.html.options
		opts    = {}
		opts.root   = getRoot()
		opts.module = config.angular.moduleName
		gulp.src src
			.pipe addToDistPath()
			.pipe gulpif minify, minifyHtml minOpts
			.pipe gulpif runNgFormify, ngFormify()
			.pipe templateCache file, opts
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "created #{file}".yellow
				defer.resolve()
		defer.promise

	run = ->
		isProd = config.env.is.prod
		file   = if isProd then 'min' else 'main'
		file   = config.fileName.views[file]
		dest   = config.dist.rb.client.scripts.dir
		src    = [].concat glob.views.rb, glob.views.app
		runTask src, dest, file, isProd

	runSingle = -> # todo: optimize for one file
		run()

	runMulti = ->
		run()

	# register task
	# =============
	return runSingle() if forWatchFile
	gulp.task "#{config.rb.prefix.task}template-cache", -> runMulti()



