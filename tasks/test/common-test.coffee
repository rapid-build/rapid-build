module.exports = (gulp, config) ->
	gulpSequence = require('gulp-sequence').use gulp
	promiseHelp  = require "#{config.req.helpers}/promise"

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}common-test", (cb) ->
		return promiseHelp.get() unless config.build.client
		gulpSequence(
			"#{config.rb.prefix.task}clean-rb-test-src" # all generated files
			[
				"#{config.rb.prefix.task}build-inject-angular-mocks"
				"#{config.rb.prefix.task}copy-angular-mocks"
			]
			"#{config.rb.prefix.task}copy-tests"
			"#{config.rb.prefix.task}build-test-files"
			"#{config.rb.prefix.task}run-tests"
			cb
		)

