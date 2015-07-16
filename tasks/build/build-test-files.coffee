module.exports = (gulp, config) ->
	q               = require 'q'
	path            = require 'path'
	rename          = require 'gulp-rename'
	template        = require 'gulp-template'
	log             = require "#{config.req.helpers}/log"
	pathHelp        = require "#{config.req.helpers}/path"
	promiseHelp     = require "#{config.req.helpers}/promise"
	format          = require("#{config.req.helpers}/format")()

	# Global Objects
	# ==============
	DevFiles  = {}
	TestFiles = client:
		scriptsTestCount: 0
		stylesTestCount:  0
		scripts: []
		styles: []

	# Build Task
	# ==========
	buildTask = ->
		src  = path.join config.templates.dir, 'test-files.tpl'
		dest = config.templates.files.dest.dir
		file = 'test-files.json'
		data = format.json TestFiles
		defer = q.defer()
		gulp.src src
			.pipe rename file
			.pipe template testFiles: data
			.pipe gulp.dest dest
			.on 'end', ->
				console.log 'test-files.json built'.yellow
				defer.resolve()
		defer.promise

	# Single Tasks
	# ============
	setTestFiles = (type) ->
		defer  = q.defer()
		appDir = pathHelp.format config.app.dir
		src    = [].concat(
			config.test.dist.rb.client[type]
			config.test.dist.app.client[type]
		)
		gulp.src src, buffer: false
			.on 'data', (file) ->
				_path = pathHelp.format(file.path).replace "#{appDir}/", ''
				TestFiles.client["#{type}TestCount"]++
				TestFiles.client[type].push _path
			.on 'end', ->
				defer.resolve()
		defer.promise

	addDevFilesToTestFiles = (type) ->
		TestFiles.client[type] = [].concat(
			DevFiles[type]
			TestFiles.client[type]
		)
		promiseHelp.get()

	# Multi Tasks
	# ===========
	setDevFiles = ->
		files    = require config.templates.files.dest.path
		DevFiles =
			scripts: files.client.scripts
			styles:  files.client.styles
		promiseHelp.get()

	setMultiTestFiles = ->
		defer = q.defer()
		q.all([
			setTestFiles 'scripts'
			setTestFiles 'styles'
		]).done -> defer.resolve()
		defer.promise

	addMultiDevFilesToTestFiles = ->
		defer = q.defer()
		q.all([
			addDevFilesToTestFiles 'scripts'
			addDevFilesToTestFiles 'styles'
		]).done -> defer.resolve()
		defer.promise

	# Main Task
	# =========
	runTask = -> # synchronously
		defer = q.defer()
		tasks = [
			-> setDevFiles()
			-> setMultiTestFiles()
			-> addMultiDevFilesToTestFiles()
			-> buildTask()
		]
		tasks.reduce(q.when, q()).done ->
			# log.json DevFiles, 'dev files ='
			# log.json TestFiles, 'test files ='
			defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-test-files", ->
		runTask()




