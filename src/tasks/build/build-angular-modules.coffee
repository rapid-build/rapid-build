module.exports = (config, gulp) ->
	q           = require 'q'
	log         = require "#{config.req.helpers}/log"
	rename      = require 'gulp-rename'
	template    = require 'gulp-template'
	promiseHelp = require "#{config.req.helpers}/promise"

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
				.pipe rename file
				.pipe template data
				.pipe gulp.dest dest
				.on 'end', ->
					_file = "#{file.split('.')[0]}.js"
					log.task "built angular modules file: #{_file}"
					defer.resolve()
			defer.promise

	# return
	# ======
	return promiseHelp.get() if config.exclude.default.client.files
	api.runTask(
		config.templates.angularModules.src.path
		config.templates.angularModules.dest.dir
		config.templates.angularModules.dest.file
	)

