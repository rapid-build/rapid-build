module.exports = (config) ->
	q           = require 'q'
	open        = require 'open'
	promiseHelp = require "#{config.req.helpers}/promise"

	api =
		runTask: (port) ->
			defer = q.defer()
			open "http://localhost:#{port}/", ->
				defer.resolve()
			defer.promise

	# return
	# ======
	return promiseHelp.get() unless config.build.server
	return promiseHelp.get() unless config.browser.open
	api.runTask config.ports.server