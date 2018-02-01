module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.server

	# requires
	# ========
	q = require 'q'

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			gulp.series([
				"#{config.rb.prefix.task}copy-server-tests"
				"#{config.rb.prefix.task}run-server-tests"
				(done) -> defer.resolve message: "completed task: #{Task.name}"; done()
			])()
			defer.promise

	# return
	# ======
	api.runTask()

