module.exports = (config, gulp) ->
	q    = require 'q'
	path = require 'path'

	# tasks
	# =====
	copyTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			tasks = []
			defer = q.defer()
			pkg   = 'package.json'
			for appOrRb in ['app','rb']
				continue if appOrRb is 'rb' and config.exclude.default.server.files
				src  = path.join config.src[appOrRb].server.dir, pkg
				dest = config.dist[appOrRb].server.scripts.dir
				do (src, dest) ->
					tasks.push ->
						copyTask src, dest

			tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()