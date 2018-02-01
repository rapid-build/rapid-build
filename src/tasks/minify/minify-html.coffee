module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() if config.minify.html.templateCache

	# requires
	# ========
	q          = require 'q'
	path       = require 'path'
	minifyHtml = require 'gulp-htmlmin'
	log        = require "#{config.req.helpers}/log"

	minifyTask = (appOrRb) ->
		defer = q.defer()
		return promiseHelp.get defer unless config.minify.html.views
		minOpts = config.minify.html.options

		gulp.src config.glob.dist[appOrRb].client.views.all
			.on 'error', (e) -> defer.reject e
			.pipe minifyHtml minOpts
			.pipe gulp.dest config.dist[appOrRb].client.views.dir
			.on 'end', ->
				message = "minified #{appOrRb} dist views"
				defer.resolve { message }
		defer.promise

	minifyTasks = ->
		q.all([
			minifyTask 'rb'
			minifyTask 'app'
		]).then ->
			message = "minified html in: #{config.dist.app.client.dir}"
			log.task message
			{ message }

	moveTask = -> # move to rb .temp folder
		defer = q.defer()
		src   = "#{config.glob.dist.rb.client.views.all}/*"
		dest  = path.join(
					config.temp.client.dir
					config.rb.prefix.distDir
					config.dist.rb.client.views.dirName
				)
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe gulp.dest dest
			.on 'end', ->
				message = "completed: copied views from .temp directory"
				defer.resolve { message }
		defer.promise

	# API
	# ===
	api =
		runTask: -> # template-cache task minifies the html
			tasks = [
				-> minifyTasks()
				-> moveTask()
			]
			tasks.reduce(q.when, q()).then ->
				# log: 'minor'
				message: "completed task: #{Task.name}"

	# return
	# ======
	api.runTask()


