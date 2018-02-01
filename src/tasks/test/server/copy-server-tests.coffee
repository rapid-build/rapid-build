module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.server
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q           = require 'q'
	babel       = require 'gulp-babel'
	coffee      = require 'gulp-coffee'
	plumber     = require 'gulp-plumber'
	taskRunner  = require("#{config.req.helpers}/task-runner") config
	taskManager = require("#{config.req.manage}/task-manager") config, gulp

	coffeeTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe plumber()
			.pipe coffee bare: true
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "compiled coffee server tests"
		defer.promise

	es6Task = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe plumber()
			.pipe babel()
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "compiled es6 server tests"
		defer.promise

	jsTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "copied js server tests"
		defer.promise

	compileWatchFile = ->
		ext  = Task.opts.watchFile.extname.replace '.', ''
		src  = Task.opts.watchFile.path
		dest = Task.opts.watchFile.rbDistDir
		switch ext
			when 'js'     then jsTask src, dest
			when 'es6'    then es6Task src, dest
			when 'coffee' then coffeeTask src, dest

	# API
	# ===
	api =
		runSingle: -> # synchronously
			tasks = [
				-> compileWatchFile()
				-> taskManager.runWatchTask 'run-server-tests', watchFilePath: Task.opts.watchFile.rbDistPath
			]
			tasks.reduce(q.when, q()).then ->
				message: "copied test script to: #{config.dist.app.server.test.dir}"

		runMulti: ->
			q.all([
				taskRunner.async coffeeTask, 'test', 'coffee', ['server'], Task
				taskRunner.async es6Task,    'test', 'es6',    ['server'], Task
				taskRunner.async jsTask,     'test', 'js',     ['server'], Task
			]).then ->
				log: true
				message: "copied test scripts to: #{config.dist.app.server.test.dir}"

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()



