module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	log          = require "#{config.req.helpers}/log"
	promiseHelp  = require "#{config.req.helpers}/promise"
	taskHelp     = require("#{config.req.helpers}/tasks") config, gulp

	# API
	# ===
	api =
		runTask: -> # synchronously
			return promiseHelp.get() unless config.build.client
			calledFromMinTask = taskOpts.calledFrom is 'minify-task'
			skipInCommonTask  = config.env.is.prod and not calledFromMinTask
			defer = q.defer()
			tasks = [
				-> # only run in common-client task
					return promiseHelp.get() if calledFromMinTask
					taskHelp.startTask '/format/absolute-css-urls', taskOpts

				-> # skip in common-client task if prod build
					return promiseHelp.get() if config.dist.client.paths.absolute
					return promiseHelp.get() if skipInCommonTask
					taskHelp.startTask '/format/relative-css-urls', taskOpts
			]
			tasks.reduce(q.when, q()).done ->
				# log.task 'updated css urls', 'minor'
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()

