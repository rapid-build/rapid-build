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
			files:   config.glob.browserSync
			proxy:   "http://localhost:#{config.ports.server}/"
			port:    config.ports.reload
			ui:      port: config.ports.reloadUI
			browser: 'google chrome'
			open:    config.browser.open
		@

	# getters
	# =======
	get: ->
		@bs

	getBsConfig: ->
		@bsConfig



