module.exports = (config) ->
	q              = require 'q'
	path           = require 'path'
	promiseHelp    = require "#{config.req.helpers}/promise"
	stopServerFile = path.join config.dist.rb.server.scripts.path, 'stop-server.js'

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.build.server
			defer      = q.defer()
			stopServer = require stopServerFile
			stopServer().done -> defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()
