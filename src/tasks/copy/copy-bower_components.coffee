module.exports = (config, gulp) ->
	q           = require 'q'
	path        = require 'path'
	es          = require 'event-stream'
	log         = require "#{config.req.helpers}/log"
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
		return [] unless Object.keys(excludes).length
		return [] unless excludes.bower
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

	# API
	# ===
	api =
		runTask: ->
			defer     = q.defer()
			rbExclude = true if config.exclude.default.client.files
			rbExclude = true if config.exclude.angular.files
			q.all([
				getComponents 'rb', rbExclude
				getComponents 'app'
			]).done ->
				log.task "copied bower components to: #{config.dist.app.client.dir}"
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()


