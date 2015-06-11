module.exports = (gulp, config, watchFile={}) ->
	q            = require 'q'
	less         = require 'gulp-less'
	plumber      = require 'gulp-plumber'
	tasks        = require("#{config.req.helpers}/tasks")()
	forWatchFile = !!watchFile.path

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe plumber()
			.pipe less()
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	runSingle = ->
		runTask watchFile.path, watchFile.rbDistDir

	runMulti = ->
		tasks.run.all(
			config, runTask,
			'styles', 'less',
			['client']
		)

	# register task
	# =============
	return runSingle() if forWatchFile
	gulp.task "#{config.rb.prefix.task}less", -> runMulti()