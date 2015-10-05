module.exports = (gulp, config) ->
	q           = require 'q'
	fs          = require 'fs'
	del         = require 'del'
	path        = require 'path'
	Server      = require('karma').Server
	moduleHelp  = require "#{config.req.helpers}/module"
	promiseHelp = require "#{config.req.helpers}/promise"
	format      = require("#{config.req.helpers}/format")()
	resultsFile = path.join config.dist.app.client.dir, 'test-results.json'

	# Global
	# ======
	TestResults = status: 'passed', total: 0, passed: 0, failed: 0

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

	formatScripts = (_scripts) ->
		scripts = []
		tests   = config.glob.dist.app.client.test.js[0]
		for script in _scripts
			isTest = script.indexOf(config.dist.app.client.test.dir) isnt -1
			continue if isTest
			isAppScript = script.indexOf(config.dist.app.client.scripts.dir) isnt -1
			watched     = isAppScript
			scripts.push { watched, pattern: script }
		scripts.push { watched: true, pattern: tests }
		scripts

	updateTestResults = (results) ->
		TestResults.status = if !!results.exitCode then 'failed' else 'passed'
		TestResults.total  = results.success + results.failed
		TestResults.passed = results.success
		TestResults.failed = results.failed
		TestResults

	hasTestsCheck = (cnt) ->
		return true if cnt
		console.log 'no test scripts to run'.yellow
		false

	startKarmaServer = (karmaConfig, defer) ->
		server = new Server karmaConfig, (exitCode) ->
		server.start()
		server.on 'run_complete', (browsers, results) ->
			updateTestResults results
			defer.resolve()
		server

	# tasks
	# =====
	cleanResultsFile = (src) ->
		defer = q.defer()
		del(src, force:true).then (paths) ->
			defer.resolve()
		defer.promise

	runTests = ->
		defer       = q.defer()
		tests       = getTestsFile()
		karmaConfig = getKarmaConfig()
		testCnt     = tests.scriptsTestCount
		return promiseHelp.get defer unless hasTestsCheck testCnt
		karmaConfig.files = tests.scripts
		startKarmaServer karmaConfig, defer
		defer.promise

	runDevTests = ->
		defer         = q.defer()
		tests         = getTestsFile()
		karmaConfig   = getKarmaConfig()
		testCnt       = tests.scriptsTestCount
		karmaConfig.files     = formatScripts tests.scripts
		karmaConfig.autoWatch = true
		karmaConfig.singleRun = false
		startKarmaServer karmaConfig, defer
		defer.promise

	writeResultsFile = (file) ->
		return promiseHelp.get() unless TestResults.status is 'failed'
		fs.writeFileSync file, format.json TestResults
		promiseHelp.get()

	failureCheck = ->
		return promiseHelp.get() if TestResults.status is 'passed'
		process.on 'exit', ->
			msg = "Client test failed - created #{resultsFile}"
			console.error msg.error
		.exit 1

	runDefaultTask = -> # synchronously
		defer = q.defer()
		tasks = [
			-> cleanResultsFile resultsFile
			-> runTests()
			-> writeResultsFile resultsFile
			-> failureCheck()
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	runDevTask = -> # synchronously
		defer = q.defer()
		tasks = [
			-> cleanResultsFile resultsFile
			-> runDevTests()
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	runTask = (isDev) ->
		return promiseHelp.get() unless config.build.client
		return promiseHelp.get() if config.exclude.angular.files
		return runDevTask() if isDev
		runDefaultTask()

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}run-client-tests", ->
		runTask()

	gulp.task "#{config.rb.prefix.task}run-client-tests:dev", ->
		runTask true



