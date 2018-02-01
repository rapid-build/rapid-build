module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q          = require 'q'
	taskRunner = require("#{config.req.helpers}/task-runner") config

	runTask = (src, dest, opts={}) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
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
			promise = taskRunner.async runTask, 'scripts', 'js', [loc], Task
			promise.then ->
				log: true
				message: "copied js to: #{config.dist.app[loc].dir}"

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti Task.opts.loc