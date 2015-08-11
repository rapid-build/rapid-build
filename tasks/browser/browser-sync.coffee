module.exports = (gulp, config) ->
	q           = require 'q'
	browserSync = require 'browser-sync'
	bs          = browserSync.create()

	# helpers
	# =======
	getBsConfig = ->
		files:   config.glob.browserSync
		proxy:   "http://localhost:#{config.ports.server}/"
		port:    config.ports.reload
		ui:      port: config.ports.reloadUI
		browser: 'google chrome'
		# open: false

	# events
	# ======
	bs.emitter.on 'serverRestart', ->
		return if not bs.active
		setTimeout ->
			bs.reload stream:false
		, 1000

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}browser-sync", ->
		defer    = q.defer()
		bsConfig = getBsConfig()
		bs.init bsConfig, ->
			defer.resolve()
		defer.promise

	bs