module.exports = (gulp, config) ->
	q = require 'q'

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	gulp.task "#{config.rb.prefix.task}server-copy-config", ->
		runTask(
			config.json.config.path
			config.dist.rb.server.scripts.dir
		)