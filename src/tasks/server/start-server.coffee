module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.server
	return promiseHelp.get() if config.exclude.default.server.files

	# requires
	# ========
	q = require 'q'

	# API
	# ===
	api =
		runTask: ->
			taskName = if Task.opts.env is 'dev' then 'nodemon' else 'spawn-server'
			defer    = q.defer()
			gulp.series([
				"#{config.rb.prefix.task}#{taskName}"
				(done) -> defer.resolve message: "completed task: #{Task.name}"; done()
			])()
			defer.promise

	# return
	# ======
	api.runTask()