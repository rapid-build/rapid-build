module.exports = (gulp, config, watchFile={}) ->
	q            = require 'q'
	tasks        = require("#{config.req.helpers}/tasks")()
	forWatchFile = !!watchFile.path

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	runSingle = ->
		runTask watchFile.path, watchFile.rbDistDir

	runMulti = (loc) ->
		tasks.run.async(
			config, runTask,
			'scripts', 'js',
			[loc]
		)

	# register task
	# =============
	return runSingle() if forWatchFile

	gulp.task "#{config.rb.prefix.task}copy-js:client", ->
		runMulti 'client'

	gulp.task "#{config.rb.prefix.task}copy-js:server", ->
		runMulti 'server'