module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.server
	return promiseHelp.get() if config.exclude.default.server.files

	# requires
	# ========
	q              = require 'q'
	serverInfoFile = config.dist.rb.server.scripts.info
	serverInfo     = require serverInfoFile

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			process.on 'SIGINT', -> process.exit 0
			try
				process.kill serverInfo.pid, 'SIGINT'
				message = "Server Stopped on Port #{serverInfo.port}"
				defer.resolve { log: 'alert', message }
			catch e
				e.message = "Failed to Stop the Server: #{e.message}"
				defer.reject e
				process.exit 1

			defer.promise

	# return
	# ======
	api.runTask()
