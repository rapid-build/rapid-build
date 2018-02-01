module.exports =
	# props
	# =====
	q: null
	bs: {}
	bsConfig: {}

	# public methods
	# ==============
	init: (config) -> # :promise
		q = @getQ()
		return q() unless config.browser.reload
		return q() unless config.build.server
		return q() if config.exclude.default.server.files
		@set()
		.setBsConfig config
		._initBs() # returns promise

	isRunning: -> # :boolean
		!!@bs.active

	restart: -> # :promise
		q = @getQ()
		return q() unless @isRunning()
		@bs.reload stream:false
		q message: 'browser-sync restarted'

	delayedRestart: -> # :promise
		q = @getQ()
		return q() unless @isRunning()
		defer = q.defer()
		setTimeout =>
			@restart().then (res) ->
				defer.resolve message: 'browser-sync restarted with delay'
		, 1000
		defer.promise

	# private methods
	# ===============
	_initBs: -> # :promise
		q     = @getQ()
		defer = q.defer()
		@bs.init @bsConfig, (e) ->
			return defer.reject e if e
			defer.resolve message: 'browser-sync started'
		defer.promise

	# setters
	# =======
	set: -> # :this
		@bs = require('browser-sync').create()
		@

	setBsConfig: (config) -> # :this
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
	get: -> # :bs
		@bs

	getBsConfig: -> # :bsConfig
		@bsConfig

	getQ: -> # :{}
		return @q if @q
		@q = require 'q'



