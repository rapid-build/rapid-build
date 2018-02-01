module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() if config.angular.httpBackend.enabled
	return promiseHelp.get() if config.exclude.default.client.files

	# requires
	# ========
	q        = require 'q'
	path     = require 'path'
	rename   = require 'gulp-rename'
	template = require 'gulp-template'

	# helpers
	# =======
	getData = ->
		data = moduleName: config.angular.moduleName

	# tasks
	# =====
	buildTask = (src, dest, file, data={}) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe rename file
			.pipe template data
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "completed task: #{Task.name}"
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			data = getData()
			src  = path.join config.templates.dir, 'inject-angular-mocks.tpl'
			dest = config.src.rb.client.test.dir
			file = 'inject-angular-mocks.coffee'
			buildTask(src, dest, file, data).then ->
				# log: 'minor'
				message: 'built inject-angular-mocks.coffee'

	# return
	# ======
	api.runTask()


