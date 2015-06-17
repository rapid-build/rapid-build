module.exports = (gulp, config) ->
	q         = require 'q'
	minifyCss = require 'gulp-minify-css'

	runTask = (appOrRb) ->
		defer = q.defer()
		gulp.src config.glob.dist[appOrRb].client.styles.all
			.pipe minifyCss()
			.pipe gulp.dest config.dist[appOrRb].client.styles.dir
			.on 'end', ->
				console.log "minified #{appOrRb} dist styles".yellow
				defer.resolve()
		defer.promise

	runTasks = ->
		defer = q.defer()
		q.all([
			runTask 'rb'
			runTask 'app'
		]).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}minify-css", ->
		runTasks()