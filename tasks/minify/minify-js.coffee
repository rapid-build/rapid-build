module.exports = (config, gulp) ->
	q        = require 'q'
	gulpif   = require 'gulp-if'
	minifyJs = require 'gulp-uglify'

	runTask = (appOrRb) ->
		defer   = q.defer()
		minify  = config.minify.js.scripts
		minOpts = mangle: config.minify.js.mangle
		gulp.src config.glob.dist[appOrRb].client.scripts.all
			.pipe gulpif minify, minifyJs minOpts
			.pipe gulp.dest config.dist[appOrRb].client.scripts.dir
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