module.exports = (gulp, config) ->
	q         = require 'q'
	del       = require 'del'
	path      = require 'path'
	log       = require "#{config.req.helpers}/log"
	dirHelper = require("#{config.req.helpers}/dir") config

	# globs
	# =====
	globs =
		del:
			temp:
				dir: config.temp.client.dir
				paths: [
					config.temp.client.scripts.glob
					config.temp.client.styles.glob
					"!#{config.temp.client.scripts.min.path}"
					"!#{config.temp.client.styles.min.path}"
				]
			dist:
				paths: [
					"#{config.glob.dist.rb.client.all}/*.*"
					"#{config.glob.dist.app.client.bower.all}/*.*"
					"#{config.glob.dist.app.client.libs.all}/*.*"
					"#{config.glob.dist.app.client.scripts.all}/*.*"
					"#{config.glob.dist.app.client.styles.all}/*.*"
				]
	# helpers
	# =======
	getExcludes = ->
		[].concat(
			config.spa.exclude.rb.scripts
			config.spa.exclude.rb.styles
			config.spa.exclude.app.scripts
			config.spa.exclude.app.styles
		)

	getDirDelSrc = ->
		src      = globs.del.dist.paths
		excludes = getExcludes()
		src      = src.concat excludes
		src

	# tasks
	# =====
	delTask = (src) ->
		defer = q.defer()
		del src, force:true, ->
			# console.log 'cleanup complete'.yellow
			defer.resolve()
		defer.promise

	delTaskDirs = (src) ->
		defer    = q.defer()
		appDir   = path.join config.app.dir, '/'
		del src, force:true, ->
			emptyDirs = dirHelper.get.emptyDirs(
							config.dist.app.client.dir
							[ config.temp.client.dir ]
							'reverse'
						)
			del emptyDirs, force:true, ->
				console.log 'client dist cleanup complete'.yellow
				defer.resolve()
		defer.promise

	moveTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	runTasks = -> # synchronously
		defer = q.defer()
		tasks = [
			-> delTask globs.del.temp.paths
			-> delTaskDirs getDirDelSrc()
			-> moveTask config.temp.client.glob, config.dist.app.client.dir
			-> delTask globs.del.temp.dir
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}cleanup-client", ->
		runTasks()


