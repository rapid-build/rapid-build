module.exports = (gulp, config) ->
	q     = require 'q'
	karma = require('karma').server

	# karma options
	# =============
	opts =
		configFile: "#{config.req.tasks}/test/test-config.coffee"

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}run-tests", ->
		defer = q.defer()
		karma.start opts, (exitCode) ->
			console.log "Karma has exited with #{exitCode}."
			defer.resolve()
			process.exit exitCode
		defer.promise


