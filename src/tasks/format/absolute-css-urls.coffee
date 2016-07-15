module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	log          = require "#{config.req.helpers}/log"
	absCssUrls   = require "#{config.req.plugins}/gulp-absolute-css-urls"
	arrayHelp    = require "#{config.req.helpers}/array"
	promiseHelp  = require "#{config.req.helpers}/promise"
	configHelp   = require("#{config.req.helpers}/config") config
	taskHelp     = require("#{config.req.helpers}/tasks") config, gulp
	forWatchFile = !!taskOpts.watchFilePath

	# global
	# ======
	buildConfigFile = false

	# helpers
	# =======
	setBuildConfigFile = ->
		buildConfigFile = !!config.internal.getImports().length
		promiseHelp.get()

	buildSpa = ->
		taskHelp.startTask 'watch-build-spa'

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
		urlOpts.prependPath = opts.prependPath
		gulp.src src, { base }
			.pipe absCssUrls clientDist, config, urlOpts
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve()
		defer.promise

	runMulti = ->
		defer = q.defer()
		q.all([
			runTask 'rb',  'bower'
			runTask 'rb',  'libs'
			runTask 'rb',  'styles', prependPath: false, glob: 'all'
			runTask 'app', 'bower'
			runTask 'app', 'libs'
			runTask 'app', 'styles', prependPath: false, glob: 'all'
		]).done ->
			log.task 'changed all css urls to absolute'
			defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runSingle: ->
			clone = config.internal.getImports()
			opts  = prependPath: false, src: taskOpts.watchFilePath, watchFileBase: true
			runTask('app', 'styles', opts).done ->
				imports  = config.internal.getImports()
				areEqual = arrayHelp.areEqual clone, imports, true
				buildSpa() unless areEqual

		runTask: -> # synchronously
			defer = q.defer()
			tasks = [
				-> runMulti()
				-> setBuildConfigFile()
				-> configHelp.buildFile buildConfigFile, 'rebuild'
			]
			tasks.reduce(q.when, q()).done ->
				# console.log 'rb', config.internal.rb.client.css.imports
				# console.log 'app', config.internal.app.client.css.imports
				defer.resolve()
			defer.promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runTask()


