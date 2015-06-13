module.exports = (gulp, config) ->
	q          = require 'q'
	minifyHtml = require 'gulp-minify-html'

	# tasks
	# =====
	runTask = (src, dest, file) ->
		defer = q.defer()
		gulp.src src
			.pipe minifyHtml empty:true, conditionals:true, ssi:true
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "minified #{file}".yellow
				defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}minify-spa", ->
		runTask(
			config.spa.dist.path
			config.dist.app.client.dir
			config.spa.dist.file
		)


