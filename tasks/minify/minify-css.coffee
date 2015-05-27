module.exports = (gulp, config) ->
	q         = require 'q'
	rename    = require 'gulp-rename'
	minifyCss = require 'gulp-minify-css'

	runTask = (src, dest, file) ->
		defer = q.defer()
		gulp.src src
			.pipe rename file
			.pipe minifyCss()
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "created #{file}".yellow
				defer.resolve()
		defer.promise

	gulp.task "#{config.rb.prefix.task}minify-css", ->
		runTask(
			config.temp.client.styles.all.path
			config.temp.client.styles.dir
			config.temp.client.styles.min.file
		)