module.exports = (config) ->
	q             = require 'q'
	path          = require 'path'
	Jasmine       = require 'jasmine'
	Reporter      = require 'jasmine-terminal-reporter'
	jasmineExpect = path.join config.node_modules.rb.src.relPath, 'jasmine-expect', 'index.js'

	jasmine =
		# properties
		# ==========
		defer:   q.defer()
		jasmine: null
		results: status: null, total: 0, passed: 0, failed: 0, failedSpecs: []

		# public
		# ======
		init: (files) ->
			@_setJasmine()
			._setConfig files
			._setOnComplete()
			._addReporter()
			@

		execute: -> # 5 seconds is the default spec timeout
			@jasmine.execute()
			@defer.promise

		getResults: ->
			@results

		# private
		# =======
		_setJasmine: ->
			@jasmine = new Jasmine()
			@

		_setConfig: (files) ->
			@jasmine.loadConfig
				spec_dir: ''
				spec_files: files
				helpers: [ jasmineExpect ]
			@

		_setOnComplete: (defer) ->
			@jasmine.onComplete (passed) =>
				@results.status = if passed then 'passed' else 'failed'
				@defer.resolve()
			@

		_addReporter: ->
			@jasmine.addReporter new Reporter
				isVerbose: false
				showColors: true
				includeStackTrace: false

			@jasmine.addReporter
				specDone: (result) =>
					@results.total++
					return @results.passed++ if result.status is 'passed'
					@results.failed++
					@results.failedSpecs.push result.fullName
			@

