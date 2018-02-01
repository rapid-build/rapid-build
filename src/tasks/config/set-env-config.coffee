# Task is only called from the common task.
# =========================================
module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() if config.env.override # because it's already set

	# API
	# ===
	api =
		runTask: -> # RB_MODE = build mode
			config.env.set process.env.RB_MODE
			promiseHelp.get
				log: true
				message: "running #{config.env.name} build"

	# return
	# ======
	api.runTask()
