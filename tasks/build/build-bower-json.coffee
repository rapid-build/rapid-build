module.exports = (config, gulp) ->
	q        = require 'q'
	rename   = require 'gulp-rename'
	template = require 'gulp-template'

	# helpers
	# =======
	getData = ->
		version = '0.0.0'
		deps    = config.angular.bowerDeps
		total   = Object.keys(deps).length
		data    = { version, deps, total }

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
					# console.log 'bower.json built'.yellow
					defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask(
		config.templates.bowerJson.src.path
		config.templates.bowerJson.dest.dir
		config.templates.bowerJson.dest.file
	)

