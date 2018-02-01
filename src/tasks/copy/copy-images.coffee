module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q          = require 'q'
	taskRunner = require("#{config.req.helpers}/task-runner") config

	runTask = (src, dest) ->
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

		runMulti: ->
			promise = taskRunner.async runTask, 'images', 'all', ['client'], Task
			promise.then ->
				log: true
				message: "copied images to: #{config.dist.app.client.dir}"

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()