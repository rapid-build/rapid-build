module.exports = (gulp, config) ->
	q = require 'q'

	runTask = (src, dest, base, appOrRb) ->
		defer = q.defer()
		gulp.src src, { base, buffer: false }
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log "copied #{appOrRb} extra files".yellow
				defer.resolve()
		defer.promise

	runTasks = ->
		defer = q.defer()
		q.all([
			runTask(
				config.extra.copy.rb.client
				config.dist.rb.client.dir
				config.src.rb.client.dir
				'rb'
			)
			runTask(
				config.extra.copy.rb.server
				config.dist.rb.server.dir
				config.src.rb.server.dir
				'rb'
			)
			runTask(
				config.extra.copy.app.client
				config.dist.app.client.dir
				config.src.app.client.dir
				'app'
			)
			runTask(
				config.extra.copy.app.server
				config.dist.app.server.dir
				config.src.app.server.dir
				'app'
			)
		]).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}copy-extra-files", ->
		runTasks()