# for watch events: add and unlink
# ================================
module.exports = (gulp, config) ->
	gulpSequence = require('gulp-sequence').use gulp

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}watch-build-spa", (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}build-files"
			"#{config.rb.prefix.task}build-spa"
			cb
		)

