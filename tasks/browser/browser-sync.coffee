module.exports = (gulp, config) ->
	q           = require 'q'
	browserSync = require 'browser-sync'
	bs          = browserSync.create()

	bsConfig    =
		files: config.glob.browserSync
		proxy: "http://localhost:#{config.app.ports.server}/"
		port: config.app.ports.reload
		browser: 'google chrome'
		# open: false

	bs.emitter.on 'serverRestart', ->
		return if not bs.active
		setTimeout ->
			bs.reload stream:false
		, 1000

	gulp.task "#{config.rb.prefix.task}browser-sync", ->
		defer = q.defer()
		bs.init bsConfig, ->
			defer.resolve()
		defer.promise

	bs