module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.server

	# requires
	# ========
	q          = require 'q'
	uglifier   = if config.minify.server.js.es6 then 'uglify-es' else 'uglify-js'
	UglifyJS   = require uglifier
	composer   = require 'gulp-uglify/composer'
	minifyJson = require 'gulp-jsonminify'
	log        = require "#{config.req.helpers}/log"
	minifyJs   = composer UglifyJS, console

	minJsTask = (src, dest) ->
		defer = q.defer()
		return promiseHelp.get defer unless config.minify.server.js.enable
		opts  = config.minify.server.js.options
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe minifyJs opts
			.pipe gulp.dest dest
			.on 'end', ->
				message = "minified js in: #{config.dist.app.server.dir}"
				log.task message
				defer.resolve { message }
		defer.promise

	minJsonTask = (src, dest) ->
		defer = q.defer()
		return promiseHelp.get defer unless config.minify.server.json.enable
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe minifyJson()
			.pipe gulp.dest dest
			.on 'end', ->
				message = "minified json in: #{config.dist.app.server.dir}"
				log.task message
				defer.resolve { message }
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			serverDist = config.dist.app.server.scripts.dir
			exclude    = '!**/node_modules/**'
			q.all([
				minJsTask   ["#{serverDist}/**/*.js",   exclude], serverDist
				minJsonTask ["#{serverDist}/**/*.json", exclude], serverDist
			]).then ->
				# log: 'minor'
				message: "completed task: #{Task.name}"

	# return
	# ======
	api.runTask()


