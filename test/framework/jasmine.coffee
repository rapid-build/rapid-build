# API:
# jasmine.init file(s)
# jasmine.execute()
# jasmine.reExecute()
# jasmine.getResults()
# Note:
# 5 seconds is the default spec timeout
# =====================================
module.exports = (config) ->
	q             = require 'q'
	path          = require 'path'
	Jasmine       = require 'jasmine'
	Reporter      = require 'jasmine-terminal-reporter'
	isType        = require "#{config.paths.abs.test.helpers}/is-type"
	moduleHelp    = require "#{config.paths.abs.test.helpers}/module"
	jasmineExpect = path.join config.paths.rel.node_modules, 'jasmine-expect', 'index.js'

	# return
	# ======
	jasmine =
		# properties
		# ==========
		defer:   q.defer()
		files:   []
		jasmine: null
		results: status: null, total: 0, passed: 0, failed: 0, failedSpecs: []

		# public
		# ======
		init: (files) ->
			@_setJasmine()
			._setFiles files
			._setConfig()
			._setOnComplete()
			._addReporter()
			@

		execute: ->
			@jasmine.execute()
			@defer.promise

		reExecute: ->
			@_deleteCache()
			@jasmine.execute()
			@defer.promise

		getResults: ->
			@results

		# private
		# =======
		_setJasmine: ->
			@jasmine = new Jasmine()
			@

		_setFiles: (files) ->
			@files = if not isType.array files then [ files ] else files
			@

		_setConfig: ->
			@jasmine.loadConfig
				spec_dir: ''
				spec_files: @files
				helpers: [ jasmineExpect ]
			@

		_setOnComplete: (defer) ->
			@jasmine.onComplete (passed) =>
				@results.status = if passed then 'passed' else 'failed'
				@defer.resolve()
			@

		_addReporter: ->
			@jasmine.addReporter new Reporter
				isVerbose: config.test.verbose.jasmine
				showColors: true
				includeStackTrace: false

			@jasmine.addReporter
				specDone: (result) =>
					@results.total++
					return @results.passed++ if result.status is 'passed'
					@results.failed++
					@results.failedSpecs.push result.fullName
			@

		_deleteCache: ->
			@_deleteCacheSpecFiles()
			@_deleteHelperFiles()
			@

		_deleteCacheSpecFiles: ->
			specFiles = @jasmine.specFiles
			return @ unless specFiles.length
			for file in specFiles
				file = path.normalize file
				moduleHelp.cache.delete file
			@

		_deleteHelperFiles: ->
			helperFiles = @jasmine.helperFiles
			return @ unless helperFiles.length
			for file in helperFiles
				file = path.normalize file
				moduleHelp.cache.delete file
			@


