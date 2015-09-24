module.exports = (gulp, config) ->
	q           = require 'q'
	path        = require 'path'
	es          = require 'event-stream'
	promiseHelp = require "#{config.req.helpers}/promise"
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

	getExcludeFromDist = (appOrRb) ->
		excludes = config.exclude[appOrRb].from.dist.client
		return [] if not Object.keys(excludes).length
		return [] if not excludes.bower
		excludes.bower.all

	runTask = (src, dest, appOrRb) ->
		defer = q.defer()
		return promiseHelp.get defer if not src or not src.paths.absolute.length
		absSrc   = src.paths.absolute
		excludes = getExcludeFromDist appOrRb
		absSrc   = absSrc.concat excludes
		gulp.src absSrc
			.pipe addDistBasePath src.paths.relative
			.pipe removeMin()
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	getComponents = (appOrRb, exclude) ->
		return promiseHelp.get() if exclude
		runTask(
			bowerHelper.get.src appOrRb
			config.dist[appOrRb].client.bower.dir
			appOrRb
		)

	runTasks = ->
		defer = q.defer()
		q.all([
			getComponents 'rb', config.exclude.angular.files
			getComponents 'app'
		]).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}copy-bower_components", ->
		return promiseHelp.get() unless config.build.client
		runTasks()


