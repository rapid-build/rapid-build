module.exports = (gulp, config) ->
	q        = require 'q'
	minifyJs = require 'gulp-uglify'

	runTask = (appOrRb) ->
		defer = q.defer()
		gulp.src config.glob.dist[appOrRb].client.scripts.all
			# .pipe minifyJs mangle:false
			.pipe minifyJs()
			.pipe gulp.dest config.dist[appOrRb].client.scripts.dir
			.on 'end', ->
				console.log "minified #{appOrRb} dist scripts".yellow
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
	gulp.task "#{config.rb.prefix.task}minify-js", ->
		runTasks()