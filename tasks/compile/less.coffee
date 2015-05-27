module.exports = (gulp, config, file={}) ->
	q       = require 'q'
	less    = require 'gulp-less'
	tasks   = require("#{config.req.helpers}/tasks")()
	forFile = !!file.path

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe less()
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	runSingle = ->
		runTask file.path, file.rbDistDir

	runMulti = ->
		tasks.run.all(
			config, runTask,
			'styles', 'less',
			['client']
		)

	return runSingle() if forFile
	gulp.task "#{config.rb.prefix.task}less", -> runMulti()