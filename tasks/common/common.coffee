# First task to run for all API tasks - Will only run once.
# =========================================================
module.exports = (gulp, config) ->
	cnt          = 1 # technique to only run this task once
	gulpSequence = require('gulp-sequence').use gulp
	promiseHelp  = require "#{config.req.helpers}/promise"

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}common", (cb) ->
		return promiseHelp.get() if cnt > 1
		cnt++
		gulpSequence(
			"#{config.rb.prefix.task}set-env-config" # must be first and only called here
			"#{config.rb.prefix.task}clean-dist"
			"#{config.rb.prefix.task}build-config"
			cb
		)

