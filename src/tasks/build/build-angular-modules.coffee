module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() if config.exclude.default.client.files

	# requires
	# ========
	q        = require 'q'
	rename   = require 'gulp-rename'
	template = require 'gulp-template'

	# helpers
	# =======
	getData = ->
		data =
			modules:    config.angular.modules
			moduleName: config.angular.moduleName

	# API
	# ===
	api =
		runTask: (src, dest, file) ->
			defer = q.defer()
			data  = getData()
			gulp.src src
				.on 'error', (e) -> defer.reject e
				.pipe rename file
				.on 'error', (e) -> defer.reject e
				.pipe template data
				.on 'error', (e) -> defer.reject e
				.pipe gulp.dest dest
				.on 'end', ->
					_file = "#{file.split('.')[0]}.js"
					defer.resolve _file
			defer.promise

	# return
	# ======
	api.runTask(
		config.templates.angularModules.src.path
		config.templates.angularModules.dest.dir
		config.templates.angularModules.dest.file
	).then (_file) ->
		log: true
		message: "built angular modules file: #{_file}"

