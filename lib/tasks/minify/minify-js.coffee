module.exports = (config, gulp) ->
	q        = require 'q'
	gulpif   = require 'gulp-if'
	minifyJs = require 'gulp-uglify'

	runTask = (appOrRb) ->
		defer   = q.defer()
		minify  = config.minify.js.scripts
		minOpts = mangle: config.minify.js.mangle
		src     = config.glob.dist[appOrRb].client.scripts.all
		dest    = config.dist[appOrRb].client.scripts.dir
		src.push '!**/*.json' # do not minify json files, uglify has issues with quoted keys
		gulp.src src
			.pipe gulpif minify, minifyJs minOpts
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "minified #{appOrRb} dist scripts".yellow
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			q.all([
				runTask 'rb'
				runTask 'app'
			]).done -> defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()