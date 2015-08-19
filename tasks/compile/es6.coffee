module.exports = (gulp, config, watchFile={}) ->
	q            = require 'q'
	babel        = require 'gulp-babel'
	plumber      = require 'gulp-plumber'
	tasks        = require("#{config.req.helpers}/tasks")()
	forWatchFile = !!watchFile.path

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe plumber()
			.pipe babel()
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	runSingle = ->
		runTask watchFile.path, watchFile.rbDistDir

	runMulti = ->
		tasks.run.async(
			config, runTask,
			'scripts', 'es6',
			['client', 'server']
		)

	# register task
	# =============
	return runSingle() if forWatchFile
	gulp.task "#{config.rb.prefix.task}es6", -> runMulti()