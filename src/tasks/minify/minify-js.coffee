module.exports = (config, gulp) ->
	q           = require 'q'
	uglifier    = if config.minify.client.js.es6 then 'uglify-es' else 'uglify-js'
	UglifyJS    = require uglifier
	composer    = require 'gulp-uglify/composer'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"
	minifyJs    = composer UglifyJS, console

	runTask = (appOrRb, opts) ->
		defer = q.defer()
		src   = config.glob.dist[appOrRb].client.scripts.all
		dest  = config.dist[appOrRb].client.scripts.dir
		src.push '!**/*.json' # do not minify json files, uglify has issues with quoted keys
		gulp.src src
			.pipe minifyJs opts
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log "minified #{appOrRb} dist scripts".yellow
				defer.resolve()
		defer.promise

	runExtraTask = (appOrRb, opts) ->
		defer = q.defer()
		src   = config.extra.minify[appOrRb].client.js
		return promiseHelp.get() unless src.length
		dest  = config.dist[appOrRb].client.dir
		gulp.src src, base: dest
			.pipe minifyJs opts
			.pipe gulp.dest dest
			.on 'end', ->
				log.task "minified extra js in: #{config.dist.app.client.dir}"
				# console.log "minified extra #{appOrRb} dist scripts".yellow
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.minify.client.js.enable
			defer  = q.defer()
			opts   = config.minify.client.js.options
			q.all([
				runTask 'rb', opts
				runTask 'app', opts
				runExtraTask 'app', opts
			]).done ->
				log.task "minified js in: #{config.dist.app.client.dir}"
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()