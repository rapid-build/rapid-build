module.exports = (config, gulp, taskOpts={}) ->
	gulpSequence = require('gulp-sequence').use gulp
	promiseHelp  = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: (cb, env) ->
			return promiseHelp.get() unless config.build.server
			serverTask = if env is 'dev' then 'nodemon' else 'spawn-server'
			gulpSequence(
				"#{config.rb.prefix.task}#{serverTask}"
				cb
			)

	# return
	# ======
	api.runTask taskOpts.taskCB, taskOpts.env


