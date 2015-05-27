module.exports = (gulp, config) ->
	q          = require 'q'
	minifyJs   = require 'gulp-uglify'
	minifyJson = require 'gulp-jsonminify'

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

	runTasks = (serverDist, exclude) ->
		defer = q.defer()
		q.all([
			minJsTask   ["#{serverDist}/**/*.js",   exclude], serverDist
			minJsonTask ["#{serverDist}/**/*.json", exclude], serverDist
		]).done -> defer.resolve()
		defer.promise

	gulp.task "#{config.rb.prefix.task}minify-server", ->
		runTasks(
			config.dist.app.server.scripts.dir
			'!**/node_modules/**'
		)