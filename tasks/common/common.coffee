# First task to run for all API tasks - Will only run once.
# =========================================================
module.exports = (config, gulp, taskOpts={}) ->
	taskOpts.cnt = 1 unless taskOpts.cnt # technique to only run this task once
	gulpSequence = require('gulp-sequence').use gulp
	promiseHelp  = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: (cb) ->
			return promiseHelp.get() if taskOpts.cnt > 1
			taskOpts.cnt++
			gulpSequence(
				"#{config.rb.prefix.task}set-env-config" # must be first and only called here
				"#{config.rb.prefix.task}clean-dist"
				"#{config.rb.prefix.task}build-config"
				cb
			)

	# return
	# ======
	api.runTask taskOpts.taskCB

