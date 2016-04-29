module.exports = (config, gulp) ->
	q           = require 'q'
	gulpif      = require 'gulp-if'
	minifyJs    = require 'gulp-uglify'
	promiseHelp = require "#{config.req.helpers}/promise"

	runTask = (appOrRb, minify, opts) ->
		defer = q.defer()
		src   = config.glob.dist[appOrRb].client.scripts.all
		dest  = config.dist[appOrRb].client.scripts.dir
		src.push '!**/*.json' # do not minify json files, uglify has issues with quoted keys
		gulp.src src
			.pipe gulpif minify, minifyJs opts
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "minified #{appOrRb} dist scripts".yellow
				defer.resolve()
		defer.promise

	runExtraTask = (appOrRb, minify, opts) ->
		defer = q.defer()
		src   = config.extra.minify[appOrRb].client.js
		return promiseHelp.get() unless src.length
		dest  = config.dist[appOrRb].client.dir
		gulp.src src, base: dest
			.pipe gulpif minify, minifyJs opts
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "minified extra #{appOrRb} dist scripts".yellow
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			defer  = q.defer()
			minify = config.minify.js.scripts
			opts   = mangle: config.minify.js.mangle
			q.all([
				runTask 'rb', minify, opts
				runTask 'app', minify, opts
				runExtraTask 'app', minify, opts
			]).done -> defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()