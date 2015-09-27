module.exports = (gulp, config) ->
	gulpSequence = require('gulp-sequence').use gulp
	promiseHelp  = require "#{config.req.helpers}/promise"

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}common-test-server", (cb) ->
		return promiseHelp.get() unless config.build.server
		gulpSequence(
			"#{config.rb.prefix.task}copy-server-tests"
			"#{config.rb.prefix.task}run-server-tests"
			cb
		)

