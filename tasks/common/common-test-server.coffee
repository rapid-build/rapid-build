module.exports = (config, gulp, taskOpts={}) ->
	gulpSequence = require('gulp-sequence').use gulp
	promiseHelp  = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: (cb) ->
			return promiseHelp.get() unless config.build.server
			gulpSequence(
				"#{config.rb.prefix.task}copy-server-tests"
				"#{config.rb.prefix.task}run-server-tests"
				cb
			)

	# return
	# ======
	api.runTask taskOpts.taskCB

