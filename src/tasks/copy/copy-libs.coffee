module.exports = (config, gulp) ->
	q = require 'q'

	runTask = (src, dest, appOrRb) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log "copied #{appOrRb} libs".yellow
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: ->
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

	# return
	# ======
	api.runTask()