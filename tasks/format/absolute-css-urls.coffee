module.exports = (gulp, config, watchFilePath) ->
	q            = require 'q'
	_            = require 'lodash'
	absCssUrls   = require "#{config.req.plugins}/gulp-absolute-css-urls"
	promiseHelp  = require "#{config.req.helpers}/promise"
	configHelp   = require("#{config.req.helpers}/config") config
	forWatchFile = !!watchFilePath

	# global
	# ======
	buildConfigFile = false

	# helpers
	# =======
	setBuildConfigFile = ->
		buildConfigFile = !!config.internal.getImports().length
		promiseHelp.get()

	buildSpa = ->
		gulp.start "#{config.rb.prefix.task}watch-build-spa"

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

	runSingle = ->
		clone = config.internal.getImports()
		opts  = prependPath: false, src: watchFilePath, watchFileBase: true
		runTask('app', 'styles', opts).done ->
			imports  = config.internal.getImports()
			areEqual = _.isEqual clone, imports
			buildSpa() unless areEqual

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
			console.log 'changed all css urls to absolute'.yellow
			defer.resolve()
		defer.promise

	runTasks = -> # synchronously
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

	# register task
	# =============
	return runSingle() if forWatchFile
	gulp.task "#{config.rb.prefix.task}absolute-css-urls", ->
		runTasks()


