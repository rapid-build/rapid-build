module.exports = (gulp, config) ->
	q          = require 'q'
	absCssUrls = require "#{config.req.plugins}/gulp-relative-to-absolute-css-urls"

	# tasks
	# =====
	cssUrlSwap = (appOrRb, type, glob='css') ->
		defer      = q.defer()
		src        = config.glob.dist[appOrRb].client[type][glob]
		dest       = config.dist[appOrRb].client[type].dir
		clientDist = config.dist.app.client.dir
		gulp.src src
			.pipe absCssUrls clientDist
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve()
		defer.promise

	runTasks = ->
		defer = q.defer()
		q.all([
			cssUrlSwap 'rb',  'bower'
			cssUrlSwap 'rb',  'libs'
			cssUrlSwap 'rb',  'styles', 'all'
			cssUrlSwap 'app', 'bower'
			cssUrlSwap 'app', 'libs'
		]).done ->
			console.log 'changed libs and bower_components css urls from relative to absolute'.yellow
			defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}relative-to-absolute-css-urls", ->
		runTasks()


