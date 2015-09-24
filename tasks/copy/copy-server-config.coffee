module.exports = (gulp, config) ->
	q           = require 'q'
	promiseHelp = require "#{config.req.helpers}/promise"

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}copy-server-config", ->
		return promiseHelp.get() unless config.build.server
		runTask(
			config.templates.config.dest.path
			config.dist.rb.server.scripts.dir
		)