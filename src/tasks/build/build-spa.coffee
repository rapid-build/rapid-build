module.exports = (config, gulp, taskOpts={}) ->
	gulpSequence = require('gulp-sequence').use gulp
	promiseHelp  = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: (cb) ->
			return promiseHelp.get() unless config.build.client
			return promiseHelp.get() if config.exclude.spa
			buildSpaFile  = 'build-spa-file'
			buildSpaFile += ':prod' if taskOpts.env is 'prod'

			gulpSequence(
				"#{config.rb.prefix.task}copy-spa"
				"#{config.rb.prefix.task}build-spa-placeholders"
				"#{config.rb.prefix.task}#{buildSpaFile}"
				cb
			)

	# return
	# ======
	api.runTask taskOpts.taskCB

