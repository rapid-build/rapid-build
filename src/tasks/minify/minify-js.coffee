module.exports = (config, gulp) ->
	q           = require 'q'
	minifyJs    = require 'gulp-uglify'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

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
			return promiseHelp.get() unless config.minify.js.scripts
			defer  = q.defer()
			opts   = mangle: config.minify.js.mangle
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