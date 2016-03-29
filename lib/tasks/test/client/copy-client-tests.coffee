module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	babel        = require 'gulp-babel'
	coffee       = require 'gulp-coffee'
	plumber      = require 'gulp-plumber'
	es2015       = require 'babel-preset-es2015'
	tasks        = require("#{config.req.helpers}/tasks") config
	babelOpts    = presets: [es2015]
	forWatchFile = !!taskOpts.watchFile

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
			.pipe babel babelOpts
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
				# -> runTest gulp, config, taskOpts.watchFile.rbDistPath
			]
			_tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise

		runMulti: ->
			defer = q.defer()
			q.all([
				tasks.run.async coffeeTask, 'test', 'coffee', ['client']
				tasks.run.async es6Task,    'test', 'es6',    ['client']
				tasks.run.async jsTask,     'test', 'js',     ['client']
			]).done -> defer.resolve()
			defer.promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()



