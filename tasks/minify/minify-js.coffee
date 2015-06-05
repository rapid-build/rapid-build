module.exports = (gulp, config) ->
	q        = require 'q'
	rename   = require 'gulp-rename'
	minifyJs = require 'gulp-uglify'

	runTask = (src, dest, file) ->
		defer = q.defer()
		gulp.src src
			.pipe rename file
			# .pipe minifyJs mangle:false
			.pipe minifyJs()
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "created #{file}".yellow
				defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}minify-js", ->
		runTask(
			config.temp.client.scripts.all.path
			config.temp.client.scripts.dir
			config.temp.client.scripts.min.file
		)