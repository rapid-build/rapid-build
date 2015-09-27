module.exports = (gulp, config) ->
	q           = require 'q'
	fs          = require 'fs'
	del         = require 'del'
	path        = require 'path'
	Server      = require('karma').Server
	moduleHelp  = require "#{config.req.helpers}/module"
	promiseHelp = require "#{config.req.helpers}/promise"
	format      = require("#{config.req.helpers}/format")()

	# Global
	# ======
	TestResults = status: null, exitCode: null

	# helpers
	# =======
	getTestsFile = ->
		tests = path.join config.templates.files.dest.dir, 'test-files.json'
		moduleHelp.cache.delete tests
		tests = require(tests).client
		tests

	getKarmaConfig = ->
		autoWatch:  false
		basePath:   config.app.dir
		browsers:   config.test.client.browsers # see config-test.coffee
		frameworks: ['jasmine', 'jasmine-matchers']
		port:       config.ports.test
		reporters:  ['dots']
		singleRun:  true

	# tasks
	# =====
	cleanResultsFile = (src, file) ->
		defer = q.defer()
		del(src, force:true).then (paths) ->
			# console.log "removed #{file}".yellow
			defer.resolve()
		defer.promise

	runTests = ->
		defer       = q.defer()
		tests       = getTestsFile()
		karmaConfig = getKarmaConfig()

		if not tests.scriptsTestCount
			console.log 'no test scripts to run'.yellow
			return promiseHelp.get defer
		else
			karmaConfig.files = tests.scripts

		server = new Server karmaConfig, (exitCode) ->
			console.log "karma has exited with #{exitCode}".yellow
			TestResults.status   = if not exitCode then 'passed' else 'failed'
			TestResults.exitCode = exitCode
			defer.resolve()

		server.start()
		defer.promise

	writeResultsFile = (file) ->
		return promiseHelp.get() unless TestResults.status is 'failed'
		fs.writeFileSync file, format.json TestResults
		promiseHelp.get()

	runTask = -> # synchronously
		defer = q.defer()
		resultsFileName = 'test-results.json'
		resultsFilePath = path.join config.dist.app.client.dir, resultsFileName
		tasks = [
			-> cleanResultsFile resultsFilePath, resultsFileName
			-> runTests()
			-> writeResultsFile resultsFilePath
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}run-client-tests", ->
		runTask()



