module.exports = (gulp, config) ->
	q   = require 'q'
	del = require 'del'

	delTask = (src) ->
		defer = q.defer()
		del src, force:true, (e) ->
			# console.log 'cleanup complete'.yellow
			defer.resolve()
		defer.promise

	moveTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	runTasks = -> # synchronously
		defer = q.defer()
		tasks = [
			->  delTask [
					config.temp.client.styles.all.path
					config.temp.client.scripts.all.path
				]
			->  delTask [
					config.glob.dist.rb.client.all
					config.glob.dist.app.client.libs.all
					config.glob.dist.app.client.scripts.all
					config.glob.dist.app.client.styles.all
				]
			->  moveTask(
					"#{config.temp.client.dir}/**/*"
					config.dist.app.client.dir
				)
			->  delTask config.temp.client.dir
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}cleanup-client", ->
		runTasks()


