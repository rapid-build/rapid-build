module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q           = require 'q'
	taskRunner  = require("#{config.req.helpers}/task-runner") config
	taskManager = require("#{config.req.manage}/task-manager") config, gulp

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
		runSingle: -> # synchronously
			watchFilePath = Task.opts.watchFile.rbDistPath
			tasks = [
				-> runTask Task.opts.watchFile.path, Task.opts.watchFile.rbDistDir
				-> taskManager.runWatchTask 'update-css-urls:dev', { watchFilePath }
			]
			tasks.reduce(q.when, q()).then ->
				# log: 'minor'
				message: "completed task: #{Task.name}"

		runMulti: ->
			promise = taskRunner.async runTask, 'styles', 'css', ['client'], Task
			promise.then ->
				log: true
				message: "copied css to: #{config.dist.app.client.dir}"

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()