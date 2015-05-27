module.exports = (gulp, config) ->
	gulpSequence = require('gulp-sequence').use gulp

	# server
	# ======
	gulp.task "#{config.rb.prefix.task}server", (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}server-nodemon"
			cb
		)

