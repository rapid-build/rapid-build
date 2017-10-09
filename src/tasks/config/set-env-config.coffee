# Task is only called from the common task.
# =========================================
module.exports = (config, gulp) ->
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: -> # RB_MODE = build mode
			return promiseHelp.get() if config.env.override # because it's already set

			config.env.set process.env.RB_MODE
			log.task "running #{config.env.name} build"
			promiseHelp.get()

	# return
	# ======
	api.runTask()
