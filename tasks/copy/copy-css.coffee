module.exports = (gulp, config, watchFile={}) ->
	q            = require 'q'
	promiseHelp  = require "#{config.req.helpers}/promise"
	tasks        = require("#{config.req.helpers}/tasks")()
	forWatchFile = !!watchFile.path
	absCssUrls   = require "#{config.req.tasks}/format/absolute-css-urls" if forWatchFile

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	runSingle = -> # synchronously
		defer  = q.defer()
		_tasks = [
			-> runTask watchFile.path, watchFile.rbDistDir
			-> absCssUrls gulp, config, watchFile.rbDistPath
		]
		_tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	runMulti = ->
		tasks.run.async(
			config, runTask,
			'styles', 'css',
			['client']
		)

	# register task
	# =============
	return runSingle() if forWatchFile
	gulp.task "#{config.rb.prefix.task}copy-css", ->
		return promiseHelp.get() unless config.build.client
		runMulti()