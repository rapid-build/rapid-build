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
				# console.log 'app.coffee built'.yellow
				defer.resolve()
		defer.promise

	# helpers
	# =======
	getData = ->
		data =
			modules:    config.angular.modules
			moduleName: config.angular.moduleName

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-angular-modules", ->
		data = getData()
		runTask(
			config.templates.angularModules.src.path
			config.templates.angularModules.dest.dir
			config.templates.angularModules.dest.file
			data
		)

