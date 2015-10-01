module.exports = (gulp, config, watchFilePath) ->
	q            = require 'q'
	del          = require 'del'
	path         = require 'path'
	fse          = require 'fs-extra'
	promiseHelp  = require "#{config.req.helpers}/promise"
	jasmine      = require("#{config.req.helpers}/jasmine") config
	resultsFile  = path.join config.dist.app.server.dir, 'test-results.json'
	forWatchFile = !!watchFilePath

	# tasks
	# =====
	cleanResultsFile = (src) ->
		defer = q.defer()
		del(src, force:true).then (paths) ->
			defer.resolve()
		defer.promise

	runTests = (files) ->
		jasmine.init(files).execute() # returns promise

	writeResultsFile = (src) ->
		results = jasmine.getResults()
		return promiseHelp.get() unless results.status is 'failed'
		fse.writeJSONSync src, results, spaces: '\t'
		promiseHelp.get()

	failureCheck = ->
		results = jasmine.getResults()
		return promiseHelp.get() if results.status is 'passed'
		process.on 'exit', ->
			msg = "Server test failed - created #{resultsFile}"
			console.error msg.error
		.exit 1

	runSingle = (file) ->
		jasmine.init(file).reExecute() # returns promise

	runMulti = -> # synchronously
		defer = q.defer()
		tasks = [
			-> cleanResultsFile resultsFile
			-> runTests config.glob.dist.app.server.test.js
			-> writeResultsFile resultsFile
			-> failureCheck()
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	return runSingle watchFilePath if forWatchFile

	gulp.task "#{config.rb.prefix.task}run-server-tests", ->
		return promiseHelp.get() unless config.build.server
		runMulti()


