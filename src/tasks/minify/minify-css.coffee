module.exports = (config, gulp) ->
	q           = require 'q'
	minifyCss   = require 'gulp-cssnano'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"
	minOpts =
		safe: true
		mergeRules: false
		normalizeUrl: false # build does this, see absolute-css-urls

	runTask = (appOrRb) ->
		defer = q.defer()
		src   = config.glob.dist[appOrRb].client.styles.all
		dest  = config.dist[appOrRb].client.styles.dir
		gulp.src src
			.pipe minifyCss minOpts
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve()
		defer.promise

	runExtraTask = (appOrRb) ->
		defer = q.defer()
		src   = config.extra.minify[appOrRb].client.css
		return promiseHelp.get() unless src.length
		dest  = config.dist[appOrRb].client.dir
		gulp.src src, base: dest
			.pipe minifyCss minOpts
			.pipe gulp.dest dest
			.on 'end', ->
				log.task "minified extra css in: #{config.dist.app.client.dir}"
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
				runExtraTask 'app'
			]).done ->
				log.task "minified css in: #{config.dist.app.client.dir}"
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()