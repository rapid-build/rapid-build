module.exports = (gulp, config) ->
	q           = require 'q'
	path        = require 'path'
	es          = require 'event-stream'
	promiseHelp = require "#{config.req.helpers}/promise"
	bowerHelper = require("#{config.req.helpers}/bower") config

	# transforms
	# ==========
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

	# tasks
	# =====
	copyTask = (src, dest) ->
		return promiseHelp.get() if not src or not src.paths.absolute.length
		defer = q.defer()
		gulp.src src.paths.absolute
			.pipe addDistBasePath src.paths.relative
			.pipe removeMin()
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	runTask = ->
		src  = bowerHelper.get.src 'rb', pkg:'angular-mocks', test:true
		dest = config.src.rb.client.test.dir
		# console.log src
		copyTask src, dest

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}copy-angular-mocks", ->
		return promiseHelp.get() if config.angular.httpBackend.enabled
		runTask()


