module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.client
	return promiseHelp.get() if config.exclude.angular.files

	# requires
	# ========
	q           = require 'q'
	del         = require 'del'
	path        = require 'path'
	fse         = require 'fs-extra'
	Server      = require('karma').Server
	log         = require "#{config.req.helpers}/log"
	moduleHelp  = require "#{config.req.helpers}/module"
	resultsFile = path.join config.dist.app.client.dir, 'test-results.json'

	# Global
	# ======
	TestResults = status: 'passed', total: 0, passed: 0, failed: 0

	# helpers
	# =======
	getTestsFile = ->
		tests = config.generated.pkg.files.testFiles
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
		log.task 'no client test scripts to run', 'alert'
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
		del(src, force:true).then (paths) ->
			message: "cleaned test results file: #{src}"

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
		fse.writeJson(file, TestResults, spaces: '\t').then ->
			message: "created test results file: #{file}"

	failureCheck = ->
		defer = q.defer()
		return promiseHelp.get defer if TestResults.status is 'passed'
		process.on 'exit', ->
			e = new Error "client test failed - created #{resultsFile}"
			log.error e
			defer.reject e
		.exit 1
		defer.promise

	runDefaultTask = -> # synchronously
		tasks = [
			-> cleanResultsFile resultsFile
			-> runTests()
			-> writeResultsFile resultsFile
			-> failureCheck()
		]
		tasks.reduce(q.when, q()).then ->
			message: "completed task: #{Task.name}"

	runDevTask = -> # synchronously
		tasks = [
			-> cleanResultsFile resultsFile
			-> runDevTests()
		]
		tasks.reduce(q.when, q()).then ->
			message: "completed task: #{Task.name}"

	# API
	# ===
	api =
		runTask: ->
			return runDevTask() if Task.opts.env is 'dev'
			runDefaultTask()

	# return
	# ======
	api.runTask()



