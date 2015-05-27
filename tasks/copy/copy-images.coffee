module.exports = (gulp, config, file={}) ->
	q       = require 'q'
	tasks   = require("#{config.req.helpers}/tasks")()
	forFile = !!file.path

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
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
			'images', 'all',
			['client'], true
		)

	return runSingle() if forFile
	gulp.task "#{config.rb.prefix.task}copy-images", -> runMulti()