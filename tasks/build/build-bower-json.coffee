module.exports = (gulp, config) ->
	q        = require 'q'
	rename   = require 'gulp-rename'
	template = require 'gulp-template'

	# task
	# ====
	runTask = (src, dest, file, data={}) ->
		defer = q.defer()
		gulp.src src
			.pipe rename file
			.pipe template data
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log 'bower.json built'.yellow
				defer.resolve()
		defer.promise

	# helpers
	# =======
	getData = ->
		version = '0.0.0'
		deps    = config.angular.bowerDeps
		total   = Object.keys(deps).length
		data    = { version, deps, total }

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-bower-json", ->
		data = getData()
		runTask(
			config.templates.bowerJson.src.path
			config.templates.bowerJson.dest.dir
			config.templates.bowerJson.dest.file
			data
		)

