module.exports = (config) ->
	q              = require 'q'
	path           = require 'path'
	promiseHelp    = require "#{config.req.helpers}/promise"
	serverInfoFile = config.dist.rb.server.scripts.info

	# helpers
	# =======
	stopServer = ->
		serverInfo = require serverInfoFile
		new Promise (resolve, reject) ->
			process.on 'SIGINT', ->
				process.exit 0

			try
				process.kill serverInfo.pid, 'SIGINT'
				msg = "Server Stopped on Port #{serverInfo.port}"
				console.log msg.yellow
			catch e
				msg = "Failed to Stop the Server: #{e.message}"
				console.log msg.error
				process.exit 1

			resolve msg

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.build.server
			return promiseHelp.get() if config.exclude.default.server.files
			defer = q.defer()
			stopServer().then ->
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()
