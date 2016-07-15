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
			elm: config.angular.bootstrap.elm
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
					log.task "built angular bootstrap file: #{_file}"
					defer.resolve()
			defer.promise

	# return
	# ======
	return promiseHelp.get() unless config.angular.bootstrap.enabled
	api.runTask(
		config.templates.angularBootstrap.src.path
		config.templates.angularBootstrap.dest.dir
		config.templates.angularBootstrap.dest.file
	)

