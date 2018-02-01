module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q          = require 'q'
	coffee     = require 'gulp-coffee'
	plumber    = require 'gulp-plumber'
	taskRunner = require("#{config.req.helpers}/task-runner") config

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe plumber()
			.pipe coffee bare: true
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
			promise = taskRunner.async runTask, 'scripts', 'coffee', [loc], Task
			promise.then ->
				log: true
				message: "compiled coffee to: #{config.dist.app[loc].dir}"

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti Task.opts.loc