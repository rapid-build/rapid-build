module.exports = (gulp, config) ->
	q         = require 'q'
	gulpif    = require 'gulp-if'
	minifyCss = require 'gulp-minify-css'
	minOpts   = advanced: false

	runTask = (appOrRb) ->
		defer  = q.defer()
		minify = config.minify.css.styles
		gulp.src config.glob.dist[appOrRb].client.styles.all
			.pipe gulpif minify, minifyCss minOpts
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