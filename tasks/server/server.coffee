module.exports = (gulp, config) ->
	gulpSequence = require('gulp-sequence').use gulp

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}server", (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}server-nodemon"
			cb
		)

