module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.server

	# requires
	# ========
	del = require 'del'

	# API
	# ===
	api =
		runTask: ->
			src = [
				config.dist.rb.server.test.dir
				config.dist.app.server.test.dir
			]
			del(src, force:true).then (paths) ->
				log: true
				message: "cleaned test files in: #{config.dist.app.server.dir}"
	# return
	# ======
	api.runTask()

