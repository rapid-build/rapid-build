module.exports = (config, gulp) ->
	q           = require 'q'
	minifyCss   = require 'gulp-minify-css'
	promiseHelp = require "#{config.req.helpers}/promise"
	minOpts =
		advanced: false
		processImport: false # inlining imports in inline-css-imports

	runTask = (appOrRb) ->
		defer = q.defer()
		src   = config.glob.dist[appOrRb].client.styles.all
		dest  = config.dist[appOrRb].client.styles.dir
		gulp.src src
			.pipe minifyCss minOpts
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "minified #{appOrRb} dist styles".yellow
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.minify.css.styles
			defer = q.defer()
			q.all([
				runTask 'rb'
				runTask 'app'
			]).done -> defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()