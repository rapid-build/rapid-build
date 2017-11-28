module.exports = (config, gulp, taskOpts={}) ->
	promiseHelp = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.build.client
			gulp.series([
				"#{config.rb.prefix.task}minify-html"
				"#{config.rb.prefix.task}inline-js-html-imports:prod"
				gulp.parallel([
					"#{config.rb.prefix.task}minify-css"
					"#{config.rb.prefix.task}minify-images" # todo
					"#{config.rb.prefix.task}minify-js"
				])
				"#{config.rb.prefix.task}build-prod-files-blueprint"
				"#{config.rb.prefix.task}build-prod-files"
				"#{config.rb.prefix.task}concat-scripts-and-styles"
				"#{config.rb.prefix.task}inline-css-imports"
				"#{config.rb.prefix.task}cleanup-client"
				"#{config.rb.prefix.task}css-file-split"
				"#{config.rb.prefix.task}update-css-urls:prod"
				"#{config.rb.prefix.task}build-spa:prod"
				"#{config.rb.prefix.task}minify-spa"
				"#{config.rb.prefix.task}cache-bust"
				(cb) -> cb(); taskOpts.taskCB()
			])()

	# return
	# ======
	api.runTask()

