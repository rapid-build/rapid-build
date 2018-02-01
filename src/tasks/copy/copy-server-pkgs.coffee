module.exports = (config, gulp, Task) ->
	q    = require 'q'
	path = require 'path'

	# tasks
	# =====
	copyTask = (src, dest, appOrRb) ->
		defer   = q.defer()
		srcOpts = allowEmpty: true
		gulp.src src, srcOpts
			.on 'error', (e) -> defer.reject e
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "copied #{appOrRb} server package.json"
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			tasks = []
			pkg   = 'package.json'

			for appOrRb in ['app','rb']
				continue if appOrRb is 'rb' and config.exclude.default.server.files
				src  = path.join config.src[appOrRb].server.dir, pkg
				dest = config.dist[appOrRb].server.scripts.dir
				do (src, dest, appOrRb) ->
					tasks.push ->
						copyTask src, dest, appOrRb

			tasks.reduce(q.when, q()).then ->
				# log: 'minor'
				message: "completed task: #{Task.name}"

	# return
	# ======
	api.runTask()