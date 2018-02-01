module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.inline.jsHtmlImports.client.enable

	# requires
	# ========
	q = require 'q'

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			gulp.series(
				"#{config.rb.prefix.task}inline-js-html-imports:prod"
				"#{config.rb.prefix.task}minify-js" # minify js again so template string gets minified
				(done) -> defer.resolve message: "completed task: #{Task.name}"; done()
			)()
			defer.promise

	# return
	# ======
	api.runTask()
