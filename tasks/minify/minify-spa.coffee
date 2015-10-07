module.exports = (config, gulp) ->
	q           = require 'q'
	minifyHtml  = require 'gulp-minify-html'
	promiseHelp = require "#{config.req.helpers}/promise"

	# tasks
	# =====
	runTask = (src, dest, file) ->
		defer   = q.defer()
		minOpts = config.minify.html.options
		gulp.src src
			.pipe minifyHtml minOpts
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "minified #{file}".yellow
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() if config.exclude.spa
			return promiseHelp.get() unless config.minify.spa.file
			runTask(
				config.spa.dist.path
				config.dist.app.client.dir
				config.spa.dist.file
			)

	# return
	# ======
	api.runTask()



