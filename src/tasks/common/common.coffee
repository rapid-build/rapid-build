# First task to run for all API tasks - Will only run once.
# =========================================================
module.exports = (config, gulp, taskOpts={}) ->
	taskOpts.cnt = 1 unless taskOpts.cnt # technique to only run this task once
	promiseHelp  = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() if taskOpts.cnt > 1
			taskOpts.cnt++
			gulp.series([
				"#{config.rb.prefix.task}set-env-config" # must be first and only called here
				"#{config.rb.prefix.task}clean-dist"
				"#{config.rb.prefix.task}generate-pkg"
				"#{config.rb.prefix.task}build-config"
				(cb) -> cb(); taskOpts.taskCB()
			])()

	# return
	# ======
	api.runTask()

