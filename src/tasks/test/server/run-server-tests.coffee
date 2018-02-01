module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.server
	forWatchFile = !!Task.opts.watchFilePath

	# requires
	# ========
	q           = require 'q'
	del         = require 'del'
	path        = require 'path'
	fse         = require 'fs-extra'
	log         = require "#{config.req.helpers}/log"
	jasmine     = require("#{config.req.helpers}/jasmine") config
	resultsFile = path.join config.dist.app.server.dir, 'test-results.json'

	# tasks
	# =====
	cleanResultsFile = (src) ->
		del(src, force:true).then (paths) ->
			message: "cleaned test results file: #{src}"

	runTests = (files) ->
		jasmine.init(files).execute() # returns promise

	writeResultsFile = (src) ->
		results = jasmine.getResults()
		return promiseHelp.get() unless results.status is 'failed'
		fse.writeJson(src, results, spaces: '\t').then ->
			message: "created test results file: #{src}"

	failureCheck = ->
		defer   = q.defer()
		results = jasmine.getResults()
		return promiseHelp.get defer if results.status is 'passed'
		process.on 'exit', ->
			e = new Error "server test failed - created #{resultsFile}"
			log.error e
			defer.reject e
		.exit 1
		defer.promise

	runMulti = -> # synchronously
		tasks = [
			-> cleanResultsFile resultsFile
			-> runTests config.glob.dist.app.server.test.js
			-> writeResultsFile resultsFile
			-> failureCheck()
		]
		tasks.reduce(q.when, q()).then ->
			message: "completed task: #{Task.name}"

	runMultiDev = -> # synchronously
		tasks = [
			-> cleanResultsFile resultsFile
			-> runTests config.glob.dist.app.server.test.js
		]
		tasks.reduce(q.when, q()).then ->
			message: "completed task: #{Task.name}"

	# API
	# ===
	api =
		runSingle: (file) ->
			jasmine.init(file).reExecute() # returns promise

		runTask: ->
			return runMultiDev() if Task.opts.env is 'dev'
			runMulti()

	# return
	# ======
	return api.runSingle Task.opts.watchFilePath if forWatchFile
	api.runTask()


