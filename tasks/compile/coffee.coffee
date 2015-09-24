module.exports = (gulp, config, watchFile={}) ->
	q            = require 'q'
	coffee       = require 'gulp-coffee'
	plumber      = require 'gulp-plumber'
	tasks        = require("#{config.req.helpers}/tasks")()
	forWatchFile = !!watchFile.path

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe plumber()
			.pipe coffee bare: true
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	runSingle = ->
		runTask watchFile.path, watchFile.rbDistDir

	runMulti = ->
		locs = config.build.getLocs()
		tasks.run.async(
			config, runTask,
			'scripts', 'coffee',
			locs
		)

	# register task
	# =============
	return runSingle() if forWatchFile
	gulp.task "#{config.rb.prefix.task}coffee", -> runMulti()