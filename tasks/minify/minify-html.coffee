module.exports = (gulp, config) ->
	q             = require 'q'
	minifyJs      = require 'gulp-uglify'
	minifyHtml    = require 'gulp-minify-html'
	templateCache = require 'gulp-angular-templatecache'

	# tasks
	# =====
	copyTask = (src, dest, loc) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "copied #{loc} views".yellow
				defer.resolve()
		defer.promise

	minifyTask = (src, dest, file) ->
		defer = q.defer()
		gulp.src src
			.pipe minifyHtml()
			.pipe templateCache file, module:'app'
			.pipe minifyJs()
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "created #{file}".yellow
				defer.resolve()
		defer.promise

	# globs
	# =====
	getGlob = (loc, type, lang) ->
		config.glob.dist[loc].client[type][lang]
	glob =
		views:
			rb:  getGlob 'rb',  'views', 'html'
			app: getGlob 'app', 'views', 'html'
			all: "#{config.temp.client.views.dir}/**/*.html"

	# dests
	# =====
	dests =
		views:
			rb:
				config.temp.client.views.dir + '/' +
				config.rb.prefix.distDir     + '/' +
				config.dist.rb.client.views.dirName
			app:
				config.temp.client.views.dir + '/' +
				config.dist.app.client.views.dirName

	runTasks = -> # synchronously
		defer = q.defer()
		tasks = [
			->  copyTask(
					glob.views.rb
					dests.views.rb
					'rb'
				)
			->  copyTask(
					glob.views.app
					dests.views.app
					'app'
				)
			->  minifyTask(
					glob.views.all
					config.temp.client.views.dir
					config.temp.client.views.min.file
				)
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}minify-html", ->
		runTasks()


