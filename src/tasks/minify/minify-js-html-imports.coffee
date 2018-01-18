module.exports = (config, gulp, taskOpts={}) ->
	promiseHelp = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.inline.jsHtmlImports.client.enable

			gulp.series(
				"#{config.rb.prefix.task}inline-js-html-imports:prod"
				"#{config.rb.prefix.task}minify-js" # minify js again so template string gets minified
				(cb) -> cb(); taskOpts.taskCB()
			)()

	# return
	# ======
	api.runTask()
