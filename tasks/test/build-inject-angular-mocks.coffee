module.exports = (gulp, config) ->
	q           = require 'q'
	path        = require 'path'
	rename      = require 'gulp-rename'
	template    = require 'gulp-template'
	promiseHelp = require "#{config.req.helpers}/promise"

	# helpers
	# =======
	getData = ->
		data = moduleName: config.angular.moduleName

	# tasks
	# =====
	buildTask = (src, dest, file, data={}) ->
		defer = q.defer()
		gulp.src src
			.pipe rename file
			.pipe template data
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log 'inject-angular-mocks.coffee built'.yellow
				defer.resolve()
		defer.promise

	runTask = ->
		data = getData()
		src  = path.join config.templates.dir, 'inject-angular-mocks.tpl'
		dest = config.src.rb.client.test.dir
		file = 'inject-angular-mocks.coffee'
		buildTask src, dest, file, data

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-inject-angular-mocks", ->
		return promiseHelp.get() if config.angular.httpBackend.enabled
		runTask()

