module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.client
	return promiseHelp.get() if config.exclude.spa
	return promiseHelp.get() if config.env.is.prod and Task.opts.env is 'dev' # skip, will run later in minify-client

	# requires
	# ========
	q = require 'q'

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			gulp.series([
				"#{config.rb.prefix.task}copy-spa"
				"#{config.rb.prefix.task}build-spa-placeholders"
				"#{config.rb.prefix.task}build-spa-file:#{Task.opts.env}"
				(done) -> defer.resolve message: "completed task: #{Task.name}"; done()
			])()
			defer.promise

	# return
	# ======
	api.runTask()

