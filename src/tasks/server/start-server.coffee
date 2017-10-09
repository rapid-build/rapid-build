module.exports = (config, gulp, taskOpts={}) ->
	promiseHelp = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.build.server
			return promiseHelp.get() if config.exclude.default.server.files
			serverTask = if taskOpts.env is 'dev' then 'nodemon' else 'spawn-server'

			gulp.series([
				"#{config.rb.prefix.task}#{serverTask}"
				(cb) -> cb(); taskOpts.taskCB()
			])()

	# return
	# ======
	api.runTask()


