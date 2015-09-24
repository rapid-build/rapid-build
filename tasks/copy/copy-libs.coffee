module.exports = (gulp, config) ->
	q           = require 'q'
	promiseHelp = require "#{config.req.helpers}/promise"

	runTask = (src, dest, appOrRb) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log "copied #{appOrRb} libs".yellow
				defer.resolve()
		defer.promise

	runTasks = ->
		defer = q.defer()
		q.all([
			runTask(
				config.glob.src.rb.client.libs.all
				config.dist.rb.client.libs.dir
				'rb'
			)
			runTask(
				config.glob.src.app.client.libs.all
				config.dist.app.client.libs.dir
				'app'
			)
		]).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}copy-libs", ->
		return promiseHelp.get() unless config.build.client
		runTasks()