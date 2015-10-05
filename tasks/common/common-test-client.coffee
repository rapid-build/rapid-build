module.exports = (gulp, config) ->
	gulpSequence = require('gulp-sequence').use gulp
	promiseHelp  = require "#{config.req.helpers}/promise"

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}common-test-client", (cb) ->
		return promiseHelp.get() unless config.build.client
		return promiseHelp.get() if config.exclude.angular.files
		gulpSequence(
			"#{config.rb.prefix.task}find-open-port:test:client"
			"#{config.rb.prefix.task}clean-rb-client-test-src" # all generated files
			[
				"#{config.rb.prefix.task}build-inject-angular-mocks"
				"#{config.rb.prefix.task}copy-angular-mocks"
			]
			"#{config.rb.prefix.task}copy-client-tests"
			"#{config.rb.prefix.task}build-client-test-files"
			cb
		)

