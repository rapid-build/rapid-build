module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() if config.exclude.spa
	return promiseHelp.get() unless config.minify.spa.file

	# requires
	# ========
	q          = require 'q'
	minifyHtml = require 'gulp-htmlmin'

	# tasks
	# =====
	runTask = (src, dest, file) ->
		defer   = q.defer()
		minOpts = config.minify.html.options
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe minifyHtml minOpts
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "completed task: #{Task.name}"
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			runTask(
				config.spa.dist.path
				config.dist.app.client.dir
				config.spa.dist.file
			).then ->
				log: true
				message: "minified #{config.spa.dist.file}"

	# return
	# ======
	api.runTask()



