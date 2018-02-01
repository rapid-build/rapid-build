module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.minify.css.styles

	# requires
	# ========
	q         = require 'q'
	minifyCss = require 'gulp-cssnano'
	log       = require "#{config.req.helpers}/log"
	minOpts =
		safe: true
		mergeRules: false
		normalizeUrl: false # build does this, see absolute-css-urls

	runTask = (appOrRb) ->
		defer = q.defer()
		src   = config.glob.dist[appOrRb].client.styles.all
		dest  = config.dist[appOrRb].client.styles.dir
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe minifyCss minOpts
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: 'completed: run task'
		defer.promise

	runExtraTask = (appOrRb) ->
		defer = q.defer()
		src   = config.extra.minify[appOrRb].client.css
		return promiseHelp.get() unless src.length
		dest  = config.dist[appOrRb].client.dir
		gulp.src src, base: dest
			.on 'error', (e) -> defer.reject e
			.pipe minifyCss minOpts
			.pipe gulp.dest dest
			.on 'end', ->
				message = "minified extra css in: #{config.dist.app.client.dir}"
				log.task message
				defer.resolve { message }
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			q.all([
				runTask 'rb'
				runTask 'app'
				runExtraTask 'app'
			]).then ->
				log: true
				message: "minified css in: #{config.dist.app.client.dir}"

	# return
	# ======
	api.runTask()