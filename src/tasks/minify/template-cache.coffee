module.exports = (config, gulp, taskOpts={}) ->
	q             = require 'q'
	path          = require 'path'
	es            = require 'event-stream'
	gulpif        = require 'gulp-if'
	minifyHtml    = require 'gulp-htmlmin'
	templateCache = require 'gulp-angular-templatecache'
	ngFormify     = require "#{config.req.plugins}/gulp-ng-formify"
	dirHelper     = require("#{config.req.helpers}/dir") config, gulp
	runNgFormify  = config.angular.ngFormify
	forWatchFile = !!taskOpts.watchFile

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
		return unless base
		return 'rb' if base.indexOf(config[loc].rb.client[type].dir) isnt -1
		'app'

	getRoot = ->
		useAbsolutePaths = config.angular.templateCache.useAbsolutePaths
		prefix           = config.angular.templateCache.urlPrefix
		prefix           = "/#{prefix}" if useAbsolutePaths and prefix[0] isnt '/'
		prefix

	# streams
	# =======
	addToDistPath = -> # add 'views/' for app and 'build/views/' for rb
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
		defer  = q.defer()
		isProd = config.env.is.prod
		file   = if isProd then 'min' else 'main'
		file   = config.fileName.views[file]
		dest   = config.dist.rb.client.scripts.dir
		src    = [].concat glob.views.rb, glob.views.app
		dirHelper.hasFiles(src).done (hasFiles) ->
			return defer.resolve() unless hasFiles
			runTask(src, dest, file, isProd).done -> defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runSingle: -> # todo: optimize for one file
			run()

		runMulti: ->
			run()

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()



