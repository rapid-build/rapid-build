module.exports = (config, gulp) ->
	q           = require 'q'
	minifyJs    = require 'gulp-uglify'
	minifyJson  = require 'gulp-jsonminify'
	promiseHelp = require "#{config.req.helpers}/promise"

	minJsTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			# .pipe minifyJs mangle:false
			.pipe minifyJs()
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "minified server js".yellow
				defer.resolve()
		defer.promise

	minJsonTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe minifyJson()
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "minified server json".yellow
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.build.server
			defer      = q.defer()
			serverDist = config.dist.app.server.scripts.dir
			exclude    = '!**/node_modules/**'
			q.all([
				minJsTask   ["#{serverDist}/**/*.js",   exclude], serverDist
				minJsonTask ["#{serverDist}/**/*.json", exclude], serverDist
			]).done -> defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()


