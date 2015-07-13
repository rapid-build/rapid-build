module.exports = (gulp, config) ->
	gulpSequence = require('gulp-sequence').use gulp

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}minify-client", (cb) ->
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
			"#{config.rb.prefix.task}cleanup-client"
			"#{config.rb.prefix.task}css-file-split"
			"#{config.rb.prefix.task}build-spa:prod"
			"#{config.rb.prefix.task}minify-spa"
			"#{config.rb.prefix.task}cache-bust"
			cb
		)

