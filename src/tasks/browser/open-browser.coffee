module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.server
	return promiseHelp.get() if config.exclude.default.server.files
	return promiseHelp.get() unless config.browser.open

	# requires
	# ========
	q    = require 'q'
	open = require 'open'

	# API
	# ===
	api =
		runTask: (port) ->
			defer = q.defer()
			open "http://localhost:#{port}/", ->
				defer.resolve message: 'opened app in browser'
			defer.promise

	# return
	# ======
	api.runTask config.ports.server