module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.client

	# requires
	# ========
	q           = require 'q'
	taskManager = require("#{config.req.manage}/task-manager") config, gulp

	# helpers
	# =======
	runTaskManager = (taskName) -> # promise
		return taskManager.runTask taskName unless Task.opts.watchFilePath
		taskManager.runWatchTask taskName, watchFilePath: Task.opts.watchFilePath

	# API
	# ===
	api =
		runTask: -> # synchronously
			calledFromMinTask = Task.opts.env is 'prod'
			skipInCommonTask  = config.env.is.prod and not calledFromMinTask
			tasks = [
				-> # only run in common-client task
					return promiseHelp.get() if calledFromMinTask
					runTaskManager 'absolute-css-urls'

				-> # skip in common-client task if prod build
					return promiseHelp.get() if config.dist.client.paths.absolute
					return promiseHelp.get() if skipInCommonTask
					runTaskManager 'relative-css-urls'
			]
			tasks.reduce(q.when, q()).then ->
				# log: 'minor'
				message: 'updated css urls'

	# return
	# ======
	api.runTask()

