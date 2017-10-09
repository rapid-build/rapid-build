module.exports = (config, gulp, taskOpts={}) ->
	promiseHelp = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.build.client
			return promiseHelp.get() if config.exclude.angular.files

			gulp.series([
				"#{config.rb.prefix.task}find-open-port:test:client"
				"#{config.rb.prefix.task}clean-rb-client-test-src" # all generated files
				gulp.parallel([
					"#{config.rb.prefix.task}build-inject-angular-mocks"
					"#{config.rb.prefix.task}copy-angular-mocks"
				])
				"#{config.rb.prefix.task}copy-client-tests"
				"#{config.rb.prefix.task}clean-rb-client:test" # if exclude.default.client.files
				"#{config.rb.prefix.task}build-client-test-files"
				(cb) -> cb(); taskOpts.taskCB()
			])()

	# return
	# ======
	api.runTask()

