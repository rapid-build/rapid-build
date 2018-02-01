module.exports = (config, gulp, Task) ->
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
		format   = spaces: '\t'
		jsonFile = config.generated.pkg.files.testFiles
		fse.writeJson(jsonFile, TestFiles, format).then ->
			message: "built test-files.json"

	# Single Tasks
	# ============
	setTestFiles = (appOrRb, type) ->
		defer  = q.defer()
		appDir = pathHelp.format config.app.dir
		src    = config.test.dist[appOrRb].client[type]
		gulp.src src, buffer: false
			.on 'error', (e) -> defer.reject e
			.on 'data', (file) ->
				_path = pathHelp.format(file.path).replace "#{appDir}/", ''
				TestFiles.client["#{type}TestCount"]++ if appOrRb is 'app'
				TestFiles.client[type].push _path
			.on 'end', ->
				message = "completed: #{Task.name} set test files"
				defer.resolve { message }
		defer.promise

	addFilesToTestFiles = (type) ->
		TestFiles.client[type] = [].concat(
			Files[type]
			TestFiles.client[type]
		)
		promiseHelp.get message: "completed: #{Task.name} added files to test files"

	# Multi Tasks
	# ===========
	setFiles = (jsonEnvFile) ->
		jsonEnvFile = path.join config.generated.pkg.files.path, jsonEnvFile
		moduleHelp.cache.delete jsonEnvFile
		files = require jsonEnvFile
		Files =
			scripts: files.client.scripts
			styles:  files.client.styles
		promiseHelp.get message: "completed: #{Task.name} set files"

	setMultiTestFiles = -> # synchronously
		tasks = [
			-> setTestFiles 'rb',  'scripts'
			-> setTestFiles 'rb',  'styles'
			-> setTestFiles 'app', 'scripts'
			-> setTestFiles 'app', 'styles'
		]
		tasks.reduce(q.when, q()).then ->
			message: "completed: #{Task.name} set multi test files"

	addMultiFilesToTestFiles = ->
		q.all([
			addFilesToTestFiles 'scripts'
			addFilesToTestFiles 'styles'
		]).then ->
			message: "completed: #{Task.name} added multi files to test files"

	# API
	# ===
	api =
		runTask: -> # synchronously
			jsonEnvFile = if config.env.is.prod then 'prod-files.json' else 'files.json'
			tasks = [
				-> setFiles jsonEnvFile
				-> setMultiTestFiles()
				-> addMultiFilesToTestFiles()
				-> buildTask()
			]
			tasks.reduce(q.when, q()).then ->
				# log.json Files, 'Files ='
				# log.json TestFiles, 'test files ='
				# log: 'minor'
				message: "completed task: #{Task.name}"

	# return
	# ======
	api.runTask()




