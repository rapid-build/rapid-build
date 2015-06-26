module.exports = (gulp, config) ->
	q           = require 'q'
	path        = require 'path'
	minifyHtml  = require 'gulp-minify-html'
	promiseHelp = require "#{config.req.helpers}/promise"

	minifyTask = (appOrRb) ->
		defer = q.defer()
		return promiseHelp.get defer if not config.minify.html.views

		minOpts = config.minify.html.options
		gulp.src config.glob.dist[appOrRb].client.views.all
			.pipe minifyHtml minOpts
			.pipe gulp.dest config.dist[appOrRb].client.views.dir
			.on 'end', ->
				console.log "minified #{appOrRb} dist views".yellow
				defer.resolve()
		defer.promise

	minifyTasks = ->
		defer = q.defer()
		q.all([
			minifyTask 'rb'
			minifyTask 'app'
		]).done -> defer.resolve()
		defer.promise

	moveTask = -> # move to rb .temp folder
		defer = q.defer()
		src   = "#{config.glob.dist.rb.client.views.all}/*"
		dest  = path.join(
					config.temp.client.dir
					config.rb.prefix.distDir
					config.dist.rb.client.views.dirName
				)
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "copied rb views".yellow
				defer.resolve()
		defer.promise

	runTasks = ->
		defer = q.defer()
		minifyTasks().done ->
			moveTask().done ->
				defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}minify-html", ->
		return runTasks() if not config.minify.html.templateCache
		promiseHelp.get()


