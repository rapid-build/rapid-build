module.exports = (config, gulp, Task) ->
	q = require 'q'

	runTask = (src, dest, appOrRb) ->
		defer   = q.defer()
		srcOpts = { follow: true }
		gulp.src src, srcOpts
			.on 'error', (e) -> defer.reject e
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "copied #{appOrRb} libs"
		defer.promise

	# API
	# ===
	api =
		runTask: ->
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
			]).then ->
				log: true
				message: "copied libs to: #{config.dist.app.client.dir}"

	# return
	# ======
	api.runTask()