module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.client

	# requires
	# ========
	q = require 'q'

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			gulp.series([
				gulp.parallel([
					"#{config.rb.prefix.task}minify-css"
					"#{config.rb.prefix.task}minify-html"
					"#{config.rb.prefix.task}minify-images" # TODO maybe
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
				"#{config.rb.prefix.task}inline-html-assets:prod"
				"#{config.rb.prefix.task}minify-js-html-imports" # needs to run on individual files
				(done) -> defer.resolve message: "completed task: #{Task.name}"; done()
			])()
			defer.promise

	# return
	# ======
	api.runTask()

