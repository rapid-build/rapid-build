module.exports = (config, gulp, taskOpts={}) ->
	promiseHelp = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: (env) ->
			return promiseHelp.get() unless config.build.client
			return promiseHelp.get() if config.exclude.spa
			return promiseHelp.get() if config.env.is.prod and env is 'dev' # skip, will run later in minify-client

			gulp.series([
				"#{config.rb.prefix.task}copy-spa"
				"#{config.rb.prefix.task}build-spa-placeholders"
				"#{config.rb.prefix.task}build-spa-file:#{env}"
				(cb) -> cb(); taskOpts.taskCB()
			])()

	# return
	# ======
	api.runTask taskOpts.env

