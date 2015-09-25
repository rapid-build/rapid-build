module.exports = (gulp, config) ->
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

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}minify-spa", ->
		return promiseHelp.get() if config.exclude.spa
		return promiseHelp.get() if not config.minify.spa.file
		runTask(
			config.spa.dist.path
			config.dist.app.client.dir
			config.spa.dist.file
		)


