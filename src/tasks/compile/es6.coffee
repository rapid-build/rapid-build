module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q          = require 'q'
	babel      = require 'gulp-babel'
	plumber    = require 'gulp-plumber'
	es2015     = require 'babel-preset-es2015'
	taskRunner = require("#{config.req.helpers}/task-runner") config
	babelOpts  = presets: [es2015]

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe plumber()
			.pipe babel babelOpts
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "completed task: #{Task.name}"
		defer.promise

	# API
	# ===
	api =
		runSingle: ->
			runTask Task.opts.watchFile.path, Task.opts.watchFile.rbDistDir

		runMulti: (loc) ->
			promise = taskRunner.async runTask, 'scripts', 'es6', [loc], Task
			promise.then ->
				log: true
				message: "compiled es6 to: #{config.dist.app[loc].dir}"

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti Task.opts.loc