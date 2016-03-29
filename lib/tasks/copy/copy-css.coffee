module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	tasks        = require("#{config.req.helpers}/tasks") config
	forWatchFile = !!taskOpts.watchFile
	absCssUrls   = require "#{config.req.tasks}/format/absolute-css-urls" if forWatchFile

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
			defer  = q.defer()
			_tasks = [
				-> runTask taskOpts.watchFile.path, taskOpts.watchFile.rbDistDir
				-> absCssUrls config, gulp, watchFilePath: taskOpts.watchFile.rbDistPath
			]
			_tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise

		runMulti: ->
			tasks.run.async runTask, 'styles', 'css', ['client']

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()