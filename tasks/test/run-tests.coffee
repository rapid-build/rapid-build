module.exports = (gulp, config) ->
	q           = require 'q'
	path        = require 'path'
	Server      = require('karma').Server
	moduleHelp  = require "#{config.req.helpers}/module"
	promiseHelp = require "#{config.req.helpers}/promise"

	# karma options
	# =============
	karmaConfig =
		autoWatch:  false
		basePath:   config.app.dir
		browsers:   config.test.browsers # see config-test.coffee
		frameworks: ['jasmine', 'jasmine-matchers']
		port:       config.ports.test
		reporters:  ['dots']
		singleRun:  true

	# helpers
	# =======
	getTests = (jsonEnvFile) ->
		jsonEnvFile = path.join config.templates.files.dest.dir, jsonEnvFile
		moduleHelp.cache.delete jsonEnvFile
		tests = require(jsonEnvFile).client
		tests

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}run-tests", ->
		defer = q.defer()
		tests = getTests 'test-files.json'

		# No Test Scripts
		if not tests.scriptsTestCount
			console.log 'no test scripts to run'.yellow
			return promiseHelp.get defer
		else
			karmaConfig.files = tests.scripts

		# Rus Tests
		server = new Server(karmaConfig, (exitCode) ->
			console.log "karma has exited with #{exitCode}".yellow
			defer.resolve()
			process.exit exitCode
		)
		server.start()
		defer.promise


