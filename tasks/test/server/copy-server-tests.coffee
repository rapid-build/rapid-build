module.exports = (gulp, config, watchFile={}) ->
	q            = require 'q'
	babel        = require 'gulp-babel'
	coffee       = require 'gulp-coffee'
	plumber      = require 'gulp-plumber'
	tasks        = require("#{config.req.helpers}/tasks")()
	promiseHelp  = require "#{config.req.helpers}/promise"
	forWatchFile = !!watchFile.path
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
		ext  = watchFile.extname.replace '.', ''
		src  = watchFile.path
		dest = watchFile.rbDistDir
		switch ext
			when 'js'     then jsTask src, dest
			when 'es6'    then es6Task src, dest
			when 'coffee' then coffeeTask src, dest

	runSingle = -> # synchronously
		defer = q.defer()
		tasks = [
			-> compileWatchFile()
			-> runTest gulp, config, watchFile.rbDistPath
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	runMulti = ->
		defer = q.defer()
		q.all([
			tasks.run.async config, coffeeTask, 'test', 'coffee', ['server']
			tasks.run.async config, es6Task,    'test', 'es6',    ['server']
			tasks.run.async config, jsTask,     'test', 'js',     ['server']
		]).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	return runSingle() if forWatchFile

	gulp.task "#{config.rb.prefix.task}copy-server-tests", ->
		return promiseHelp.get() unless config.build.server
		runMulti()



