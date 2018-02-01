module.exports = (config, gulp, Task) ->
	promiseHelp  = require "#{config.req.helpers}/promise"
	rbServerFile = config.dist.rb.server.scripts.start

	# API
	# ===
	api =
		runTask: ->
			require rbServerFile
			promiseHelp.get
				# log: 'minor'
				message: "completed task: #{Task.name}"

	# return
	# ======
	api.runTask()
