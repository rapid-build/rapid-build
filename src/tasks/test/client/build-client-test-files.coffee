module.exports = (config, gulp) ->
	q           = require 'q'
	path        = require 'path'
	fse         = require 'fs-extra'
	log         = require "#{config.req.helpers}/log"
	pathHelp    = require "#{config.req.helpers}/path"
	moduleHelp  = require "#{config.req.helpers}/module"
	promiseHelp = require "#{config.req.helpers}/promise"

	# Global Objects
	# ==============
	Files     = {}
	TestFiles = client:
		scriptsTestCount: 0
		stylesTestCount:  0
		scripts: []
		styles: []

	# Build Task
	# ==========
	buildTask = ->
		defer    = q.defer()
		format   = spaces: '\t'
		jsonFile = config.generated.pkg.files.testFiles
		fse.writeJson jsonFile, TestFiles, format, (e) ->
			console.log "built test-files.json".yellow
			defer.resolve()
		defer.promise

	# Single Tasks
	# ============
	setTestFiles = (appOrRb, type) ->
		defer  = q.defer()
		appDir = pathHelp.format config.app.dir
		src    = config.test.dist[appOrRb].client[type]
		gulp.src src, buffer: false
			.on 'data', (file) ->
				_path = pathHelp.format(file.path).replace "#{appDir}/", ''
				TestFiles.client["#{type}TestCount"]++ if appOrRb is 'app'
				TestFiles.client[type].push _path
			.on 'end', ->
				defer.resolve()
		defer.promise

	addFilesToTestFiles = (type) ->
		TestFiles.client[type] = [].concat(
			Files[type]
			TestFiles.client[type]
		)
		promiseHelp.get()

	# Multi Tasks
	# ===========
	setFiles = (jsonEnvFile) ->
		jsonEnvFile = path.join config.generated.pkg.files.path, jsonEnvFile
		moduleHelp.cache.delete jsonEnvFile
		files = require jsonEnvFile
		Files =
			scripts: files.client.scripts
			styles:  files.client.styles
		promiseHelp.get()

	setMultiTestFiles = -> # synchronously
		defer = q.defer()
		tasks = [
			-> setTestFiles 'rb',  'scripts'
			-> setTestFiles 'rb',  'styles'
			-> setTestFiles 'app', 'scripts'
			-> setTestFiles 'app', 'styles'
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	addMultiFilesToTestFiles = ->
		defer = q.defer()
		q.all([
			addFilesToTestFiles 'scripts'
			addFilesToTestFiles 'styles'
		]).done -> defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: -> # synchronously
			defer       = q.defer()
			jsonEnvFile = if config.env.is.prod then 'prod-files.json' else 'files.json'
			tasks = [
				-> setFiles jsonEnvFile
				-> setMultiTestFiles()
				-> addMultiFilesToTestFiles()
				-> buildTask()
			]
			tasks.reduce(q.when, q()).done ->
				# log.json Files, 'Files ='
				# log.json TestFiles, 'test files ='
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()




