module.exports = (config, gulp) ->
	q           = require 'q'
	path        = require 'path'
	minifyHtml  = require 'gulp-htmlmin'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

	minifyTask = (appOrRb) ->
		defer = q.defer()
		return promiseHelp.get defer unless config.minify.html.views

		minOpts = config.minify.html.options
		gulp.src config.glob.dist[appOrRb].client.views.all
			.pipe minifyHtml minOpts
			.pipe gulp.dest config.dist[appOrRb].client.views.dir
			.on 'end', ->
				# console.log "minified #{appOrRb} dist views".yellow
				defer.resolve()
		defer.promise

	minifyTasks = ->
		defer = q.defer()
		q.all([
			minifyTask 'rb'
			minifyTask 'app'
		]).done ->
			log.task "minified html in: #{config.dist.app.client.dir}"
			defer.resolve()
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
				# console.log "copied rb views".yellow
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: -> # template-cache task minifies the html
			return promiseHelp.get() if config.minify.html.templateCache
			defer = q.defer()
			minifyTasks().done ->
				moveTask().done ->
					defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()


