module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q                  = require 'q'
	path               = require 'path'
	es                 = require 'event-stream'
	gulpif             = require 'gulp-if'
	minifyHtml         = require 'gulp-htmlmin'
	templateCache      = require 'gulp-angular-templatecache'
	log                = require "#{config.req.helpers}/log"
	promiseHelp        = require "#{config.req.helpers}/promise"
	ngFormify          = require "#{config.req.plugins}/gulp-ng-formify"
	compileHtmlScripts = require "#{config.req.plugins}/gulp-compile-html-scripts"
	dirHelper          = require("#{config.req.helpers}/dir") config
	runNgFormify       = config.angular.ngFormify

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

	transformUrl = (url) -> # :string (for relative urls)
		return url unless url[0] is '/'
		url.replace '/', ''

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
		opts = {}
		opts.root         = getRoot()
		opts.module       = config.angular.moduleName
		opts.transformUrl = transformUrl unless config.angular.templateCache.useAbsolutePaths
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe addToDistPath()
			.pipe gulpif config.compile.htmlScripts.client.enable, compileHtmlScripts()
			.pipe gulpif minify, minifyHtml minOpts
			.pipe gulpif runNgFormify, ngFormify()
			.pipe templateCache file, opts
			.pipe gulp.dest dest
			.on 'end', ->
				log.task "compiled html es6 scripts to: #{config.dist.app.client.dir}" if config.compile.htmlScripts.client.enable
				log.task "created and copied #{file} to: #{config.dist.app.client.dir}"
				log.task "minified html in #{file}" if minify
				defer.resolve message: "completed: #{Task.name} run task"
		defer.promise

	run = ->
		isProd = config.env.is.prod
		file   = if isProd then 'min' else 'main'
		file   = config.fileName.views[file]
		dest   = config.dist.rb.client.scripts.dir
		src    = [].concat glob.views.rb, glob.views.app
		tasks = [
			-> dirHelper.hasFiles src
			(hasFiles) ->
				return promiseHelp.get() unless hasFiles
				runTask src, dest, file, isProd
		]
		tasks.reduce(q.when, q()).then ->
			# log: 'minor'
			message: "completed task: #{Task.name}"

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



