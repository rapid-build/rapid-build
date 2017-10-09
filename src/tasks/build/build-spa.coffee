module.exports = (config, gulp, taskOpts={}) ->
	promiseHelp = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.build.client
			return promiseHelp.get() if config.exclude.spa
			buildSpaFile  = 'build-spa-file'
			buildSpaFile += ':prod' if taskOpts.env is 'prod'

			gulp.series([
				"#{config.rb.prefix.task}copy-spa"
				"#{config.rb.prefix.task}build-spa-placeholders"
				"#{config.rb.prefix.task}#{buildSpaFile}"
				(cb) -> cb(); taskOpts.taskCB()
			])()

	# return
	# ======
	api.runTask()

