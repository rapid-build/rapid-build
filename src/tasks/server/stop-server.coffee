module.exports = (config) ->
	q              = require 'q'
	path           = require 'path'
	promiseHelp    = require "#{config.req.helpers}/promise"
	stopServerFile = config.dist.rb.server.scripts.stop

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.build.server
			return promiseHelp.get() if config.exclude.default.server.files
			defer      = q.defer()
			stopServer = require stopServerFile
			defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()
