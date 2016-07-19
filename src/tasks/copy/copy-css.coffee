module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	log          = require "#{config.req.helpers}/log"
	tasks        = require("#{config.req.helpers}/tasks") config
	taskHelp     = require("#{config.req.helpers}/tasks") config, gulp
	forWatchFile = !!taskOpts.watchFile

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runSingle: -> # synchronously
			defer         = q.defer()
			watchFilePath = taskOpts.watchFile.rbDistPath
			_tasks = [
				-> runTask taskOpts.watchFile.path, taskOpts.watchFile.rbDistDir
				-> taskHelp.startTask '/format/update-css-urls', { watchFilePath }
			]
			_tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise

		runMulti: ->
			promise = tasks.run.async runTask, 'styles', 'css', ['client']
			promise.done ->
				log.task "copied css to: #{config.dist.app.client.dir}"
			promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()