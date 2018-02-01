module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.minify.client.js.enable

	# requires
	# ========
	q        = require 'q'
	uglifier = if config.minify.client.js.es6 then 'uglify-es' else 'uglify-js'
	UglifyJS = require uglifier
	composer = require 'gulp-uglify/composer'
	log      = require "#{config.req.helpers}/log"
	minifyJs = composer UglifyJS, console

	runTask = (appOrRb, opts) ->
		defer = q.defer()
		src   = config.glob.dist[appOrRb].client.scripts.all
		dest  = config.dist[appOrRb].client.scripts.dir
		src.push '!**/*.json' # do not minify json files, uglify has issues with quoted keys
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe minifyJs opts
			.pipe gulp.dest dest
			.on 'end', ->
				message = "minified #{appOrRb} dist scripts"
				defer.resolve { message }
		defer.promise

	runExtraTask = (appOrRb, opts) ->
		defer = q.defer()
		src   = config.extra.minify[appOrRb].client.js
		return promiseHelp.get() unless src.length
		dest  = config.dist[appOrRb].client.dir
		gulp.src src, base: dest
			.on 'error', (e) -> defer.reject e
			.pipe minifyJs opts
			.pipe gulp.dest dest
			.on 'end', ->
				message = "minified extra js in: #{config.dist.app.client.dir}"
				log.task message
				defer.resolve { message }
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			opts = config.minify.client.js.options
			q.all([
				runTask 'rb', opts
				runTask 'app', opts
				runExtraTask 'app', opts
			]).then ->
				log: true
				message: "minified js in: #{config.dist.app.client.dir}"

	# return
	# ======
	api.runTask()