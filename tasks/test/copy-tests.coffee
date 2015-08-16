module.exports = (gulp, config) ->
	q       = require 'q'
	babel   = require 'gulp-babel'
	coffee  = require 'gulp-coffee'
	plumber = require 'gulp-plumber'
	tasks   = require("#{config.req.helpers}/tasks")()

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

	runMulti = ->
		defer = q.defer()
		q.all([
			tasks.run.sync config, coffeeTask, 'test', 'coffee', ['client']
			tasks.run.sync config, es6Task,    'test', 'es6',    ['client']
			tasks.run.sync config, jsTask,     'test', 'js',     ['client']
		]).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}copy-tests", ->
		runMulti()