module.exports = (gulp, config) ->
	q          = require 'q'
	minifyHtml = require 'gulp-minify-html'

	# tasks
	# =====
	runTask = (src, dest, file) ->
		defer = q.defer()
		gulp.src src
			.pipe minifyHtml()
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "minified #{file}".yellow
				defer.resolve()
		defer.promise

	gulp.task "#{config.rb.prefix.task}minify-spa", ->
		runTask(
			config.dist.app.client.spa.path
			config.dist.app.client.dir
			config.dist.app.client.spa.file
		)


