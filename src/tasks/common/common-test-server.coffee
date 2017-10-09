module.exports = (config, gulp, taskOpts={}) ->
	promiseHelp = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.build.server

			gulp.series([
				"#{config.rb.prefix.task}copy-server-tests"
				"#{config.rb.prefix.task}run-server-tests"
				(cb) -> cb(); taskOpts.taskCB()
			])()

	# return
	# ======
	api.runTask()

