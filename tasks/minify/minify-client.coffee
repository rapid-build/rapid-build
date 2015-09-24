module.exports = (gulp, config) ->
	gulpSequence = require('gulp-sequence').use gulp
	promiseHelp  = require "#{config.req.helpers}/promise"

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}minify-client", (cb) ->
		return promiseHelp.get() unless config.build.client
		gulpSequence(
			[
				"#{config.rb.prefix.task}minify-css"
				"#{config.rb.prefix.task}minify-html"
				"#{config.rb.prefix.task}minify-images"
				"#{config.rb.prefix.task}minify-js"
			]
			"#{config.rb.prefix.task}build-prod-files-blueprint"
			"#{config.rb.prefix.task}build-prod-files"
			"#{config.rb.prefix.task}concat-scripts-and-styles"
			"#{config.rb.prefix.task}inline-css-imports"
			"#{config.rb.prefix.task}cleanup-client"
			"#{config.rb.prefix.task}css-file-split"
			"#{config.rb.prefix.task}build-spa:prod"
			"#{config.rb.prefix.task}minify-spa"
			"#{config.rb.prefix.task}cache-bust"
			cb
		)

