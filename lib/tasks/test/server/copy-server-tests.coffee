module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	babel        = require 'gulp-babel'
	coffee       = require 'gulp-coffee'
	plumber      = require 'gulp-plumber'
	promiseHelp  = require "#{config.req.helpers}/promise"
	tasks        = require("#{config.req.helpers}/tasks") config
	forWatchFile = !!taskOpts.watchFile
	runTest      = require "#{config.req.tasks}/test/server/run-server-tests" if forWatchFile

	coffeeTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe plumber()
			.pipe coffee bare: true
			.pipe gulp.dest dest
			.on 'end', -> defer.resolve()
		defer.promise

	es6Task = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe plumber()
			.pipe babel()
			.pipe gulp.dest dest
			.on 'end', -> defer.resolve()
		defer.promise

	jsTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', -> defer.resolve()
		defer.promise

	compileWatchFile = ->
		ext  = taskOpts.watchFile.extname.replace '.', ''
		src  = taskOpts.watchFile.path
		dest = taskOpts.watchFile.rbDistDir
		switch ext
			when 'js'     then jsTask src, dest
			when 'es6'    then es6Task src, dest
			when 'coffee' then coffeeTask src, dest

	# API
	# ===
	api =
		runSingle: -> # synchronously
			defer  = q.defer()
			_tasks = [
				-> compileWatchFile()
				-> runTest config, gulp, watchFilePath: taskOpts.watchFile.rbDistPath
			]
			_tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise

		runMulti: ->
			return promiseHelp.get() unless config.build.server
			defer = q.defer()
			q.all([
				tasks.run.async coffeeTask, 'test', 'coffee', ['server']
				tasks.run.async es6Task,    'test', 'es6',    ['server']
				tasks.run.async jsTask,     'test', 'js',     ['server']
			]).done -> defer.resolve()
			defer.promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()



