module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFilePath

	# requires
	# ========
	q           = require 'q'
	log         = require "#{config.req.helpers}/log"
	absCssUrls  = require "#{config.req.plugins}/gulp-absolute-css-urls"
	arrayHelp   = require "#{config.req.helpers}/array"
	promiseHelp = require "#{config.req.helpers}/promise"
	configHelp  = require("#{config.req.helpers}/config") config
	taskManager = require("#{config.req.manage}/task-manager") config, gulp

	# global
	# ======
	buildConfigFile = false

	# helpers
	# =======
	setBuildConfigFile = ->
		buildConfigFile = !!config.internal.getImports().length
		promiseHelp.get message: "completed: set build config file"

	# tasks
	# =====
	runTask = (appOrRb, type, opts={}) -> # css url swap
		defer      = q.defer()
		glob       = opts.glob or 'css'
		src        = opts.src or config.glob.dist[appOrRb].client[type][glob]
		dest       = config.dist[appOrRb].client[type].dir
		base       = if opts.watchFileBase then dest else ''
		clientDist = config.dist.app.client.dir
		urlOpts    = {}
		urlOpts.rbDistDir   = config.rb.prefix.distDir
		urlOpts.rbDistPath  = config.dist.rb.client.styles.dir
		urlOpts.prependPath = opts.prependPath
		gulp.src src, { base }
			.on 'error', (e) -> defer.reject e
			.pipe absCssUrls clientDist, config, urlOpts
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "completed task: #{Task.name}"
		defer.promise

	runMulti = ->
		q.all([
			runTask 'rb',  'bower'
			runTask 'rb',  'libs'
			runTask 'rb',  'styles', prependPath: false, glob: 'all'
			runTask 'app', 'bower'
			runTask 'app', 'libs'
			runTask 'app', 'styles', prependPath: false, glob: 'all'
		]).then ->
			message: 'completed: changed all css urls to absolute'

	# API
	# ===
	api =
		runSingle: ->
			clone = config.internal.getImports()
			opts  = prependPath: false, src: Task.opts.watchFilePath, watchFileBase: true
			tasks = [
				-> runTask 'app', 'styles', opts
				->
					imports  = config.internal.getImports()
					areEqual = arrayHelp.areEqual clone, imports, true
					return promiseHelp.get() if areEqual
					taskManager.runWatchTask 'watch-build-spa'
			]
			tasks.reduce(q.when, q()).then ->
				message: "completed task: #{Task.name}"

		runTask: -> # synchronously
			tasks = [
				-> runMulti()
				-> setBuildConfigFile()
				-> configHelp.buildFile buildConfigFile, 'rebuild'
			]
			tasks.reduce(q.when, q()).then ->
				# log.json config.internal.rb.client.css.imports, 'RB INTERNAL CSS IMPORTS:'
				# log.json config.internal.app.client.css.imports, 'APP INTERNAL CSS IMPORTS:'
				log: true
				message: 'changed all css urls to absolute'

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runTask()


