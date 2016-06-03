module.exports = (config, gulp) ->
	q      = require 'q'
	rename = require 'gulp-rename'

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			src   = config.spa.src.path
			dest  = config.dist.app.client.dir
			file  = config.spa.dist.file
			gulp.src src
				.pipe rename file    # if options.spa.dist.fileName
				.pipe gulp.dest dest
				.on 'end', ->
					defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()