module.exports = (gulp, config, file={}) ->
	q       = require 'q'
	babel   = require 'gulp-babel'
	tasks   = require("#{config.req.helpers}/tasks")()
	forFile = !!file.path

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe babel()
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
			'scripts', 'es6',
			['client', 'server']
		)

	return runSingle() if forFile
	gulp.task "#{config.rb.prefix.task}es6", -> runMulti()