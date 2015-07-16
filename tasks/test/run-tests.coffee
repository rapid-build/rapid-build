module.exports = (gulp, config) ->
	q      = require 'q'
	Server = require('karma').Server

	# karma options
	# =============
	opts =
		configFile: "#{config.req.tasks}/test/test-config.coffee"

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}run-tests", ->
		defer  = q.defer()
		server = new Server opts, (exitCode) ->
			console.log "Karma has exited with #{exitCode}."
			defer.resolve()
			process.exit exitCode
		server.start()
		defer.promise


