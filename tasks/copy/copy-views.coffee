module.exports = (gulp, config) ->
	gulpSequence = require('gulp-sequence').use gulp

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}copy-views", (cb) ->
		if config.env.name is 'prod'
			task = 'template-cache'
		else if config.angular.templateCache.dev.enable
			task = 'template-cache'
		else
			task = 'copy-html'

		gulpSequence "#{config.rb.prefix.task}#{task}", cb

