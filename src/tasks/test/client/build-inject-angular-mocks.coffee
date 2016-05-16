module.exports = (config, gulp) ->
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
				# console.log 'built inject-angular-mocks.coffee'.yellow
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() if config.angular.httpBackend.enabled
			return promiseHelp.get() if config.exclude.default.client.files

			data = getData()
			src  = path.join config.templates.dir, 'inject-angular-mocks.tpl'
			dest = config.src.rb.client.test.dir
			file = 'inject-angular-mocks.coffee'
			buildTask src, dest, file, data

	# return
	# ======
	api.runTask()


