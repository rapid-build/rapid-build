module.exports = (gulp, config) ->
	gulpSequence = require('gulp-sequence').use gulp

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}copy-views", (cb) ->
		if config.env.is.prod
			if config.minify.html.templateCache
				task = 'template-cache'
			else
				task = 'copy-html'
		else if config.angular.templateCache.dev
			task = 'template-cache'
		else
			task = 'copy-html'

		gulpSequence "#{config.rb.prefix.task}#{task}", cb

