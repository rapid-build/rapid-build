# First task to run for all API tasks - Will only run once.
# =========================================================
TaskHasRan = false # technique to only run this task once
module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() if TaskHasRan
	TaskHasRan = true

	# requires
	# ========
	q = require 'q'

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			gulp.series([
				"#{config.rb.prefix.task}set-env-config" # must be first and only called here
				"#{config.rb.prefix.task}clean-dist"
				"#{config.rb.prefix.task}generate-pkg"
				"#{config.rb.prefix.task}build-config"
				(done) -> defer.resolve message: "completed task: #{Task.name}"; done()
			])()
			defer.promise

	# return
	# ======
	api.runTask()

