module.exports = (gulp, config) ->
	q           = require 'q'
	path        = require 'path'
	es          = require 'event-stream'
	bowerHelper = require("#{config.req.helpers}/bower") config

	removeMin = -> # for prod env, to avoid additional work elsewhere
		transform = (file, cb) ->
			file.path = file.path.replace '.min', ''
			cb null, file
		es.map transform

	addDistBasePath = (relPaths) ->
		transform = (file, cb) ->
			relPath   = relPaths[file.path]
			name      = path.basename relPath
			dir       = path.dirname relPath
			file.path = path.join file.base, dir, name
			cb null, file
		es.map transform

	runTask = (src, dest) ->
		defer = q.defer()
		return if not src or not src.paths.absolute.length
			defer.resolve()
			defer.promise
		gulp.src src.paths.absolute
			.pipe addDistBasePath src.paths.relative
			.pipe removeMin()
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	getComponents = (appOrRb, exclude) ->
		return if exclude
			defer = q.defer()
			defer.resolve()
			defer.promise
		runTask(
			bowerHelper.get.src appOrRb
			config.dist[appOrRb].client.bower.dir
		)

	runTasks = ->
		defer = q.defer()
		q.all([
			getComponents 'rb', config.angular.exclude.files
			getComponents 'app'
		]).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}copy-bower_components", ->
		runTasks()


