module.exports =
	# props
	# =====
	bs: {}
	bsConfig: {}

	# public methods
	# ==============
	init: (config) ->
		promiseHelp = require "#{config.req.helpers}/promise"
		return promiseHelp.get() unless config.browser.reload
		return promiseHelp.get() unless config.build.server
		return promiseHelp.get() if config.exclude.default.server.files
		@set()
		.setBsConfig config
		._initBs() # returns promise

	isRunning: ->
		!!@bs.active

	restart: ->
		return @ unless @isRunning()
		# console.log 'BROWSER SYNC RESTART:', @bs.name
		@bs.reload stream:false
		@

	delayedRestart: ->
		return @ unless @isRunning()
		setTimeout =>
			@restart()
		, 1000
		@

	# private methods
	# ===============
	_initBs: ->
		q     = require 'q'
		defer = q.defer()
		# console.log 'BROWSER SYNC STARTED', @bs.name
		@bs.init @bsConfig, ->
			defer.resolve()
		defer.promise

	# setters
	# =======
	set: ->
		@bs = require('browser-sync').create()
		@

	setBsConfig: (config) ->
		@bsConfig =
			ui:     port: config.ports.reloadUI
			port:   config.ports.reload
			open:   config.browser.open
			files:  config.glob.browserSync.files
			proxy:  "http://localhost:#{config.ports.server}/"
			notify: false # hide ui popover notification
			injectChanges: false # don't try to inject css changes, just do a page refresh
			reloadDebounce: 150  # windows fix for bundle reload (milliseconds)
			watchOptions:
				ignored: config.glob.browserSync.ignore
		@

	# getters
	# =======
	get: ->
		@bs

	getBsConfig: ->
		@bsConfig



