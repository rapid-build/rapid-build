module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() if config.angular.httpBackend.enabled
	return promiseHelp.get() if config.exclude.default.client.files

	# requires
	# ========
	q           = require 'q'
	path        = require 'path'
	es          = require 'event-stream'
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
			.on 'error', (e) -> defer.reject e
			.pipe addDistBasePath src.paths.relative
			.pipe removeMin()
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "completed task: #{Task.name} copy task"
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			src  = bowerHelper.get.src 'rb', pkg:'angular-mocks', test:true
			dest = config.src.rb.client.test.dir
			copyTask(src, dest).then ->
				# log: 'minor'
				message: "copied angular mocks to: #{dest}"

	# return
	# ======
	api.runTask()


