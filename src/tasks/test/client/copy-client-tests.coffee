module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q          = require 'q'
	babel      = require 'gulp-babel'
	coffee     = require 'gulp-coffee'
	plumber    = require 'gulp-plumber'
	es2015     = require 'babel-preset-es2015'
	taskRunner = require("#{config.req.helpers}/task-runner") config
	babelOpts  = presets: [es2015]

	coffeeTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe plumber()
			.pipe coffee bare: true
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "compiled coffee client tests"
		defer.promise

	es6Task = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe plumber()
			.pipe babel babelOpts
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "compiled es6 client tests"
		defer.promise

	jsTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "copied js client tests"
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
		runSingle: ->
			compileWatchFile().then ->
				message: "copied test script to: #{config.dist.app.client.test.dir}"

		runMulti: ->
			q.all([
				taskRunner.async coffeeTask, 'test', 'coffee', ['client'], Task
				taskRunner.async es6Task,    'test', 'es6',    ['client'], Task
				taskRunner.async jsTask,     'test', 'js',     ['client'], Task
			]).then ->
				log: true
				message: "copied test scripts to: #{config.dist.app.client.test.dir}"

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()



