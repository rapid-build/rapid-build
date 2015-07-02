module.exports = (gulp, config) ->
	q           = require 'q'
	del         = require 'del'
	path        = require 'path'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"
	dirHelper   = require("#{config.req.helpers}/dir") config
	emptyDirs   = [] # set in delFilesTask()

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
			config.exclude.rb.scripts.from.spaFile
			config.exclude.rb.styles.from.spaFile
			config.exclude.app.scripts.from.spaFile
			config.exclude.app.styles.from.spaFile
		)

	getFilesDelSrc = ->
		src      = globs.del.dist.paths
		excludes = getExcludes()
		src      = src.concat excludes
		src

	# tasks
	# =====
	delTask = (src, msg) ->
		defer = q.defer()
		del src, force:true, ->
			console.log msg.yellow if msg
			defer.resolve()
		defer.promise

	delEmptyDirsTask = (msg) ->
		return promiseHelp.get() if not emptyDirs.length
		delTask emptyDirs, msg

	delFilesTask = (msg) ->
		defer = q.defer()
		src   = getFilesDelSrc()
		del src, force:true, ->
			emptyDirs = dirHelper.get.emptyDirs(
							config.dist.app.client.dir
							[ config.temp.client.dir ]
							'reverse'
						)
			console.log msg.yellow if msg
			defer.resolve()
		defer.promise

	moveTask = (src, dest, msg) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				console.log msg.yellow if msg
				defer.resolve()
		defer.promise

	runTasks = -> # synchronously
		defer = q.defer()
		tasks = [
			-> delTask globs.del.temp.paths, 'deleted files in .temp directory'
			-> delFilesTask 'deleted files in client root'
			-> delEmptyDirsTask 'deleted empty directories'
			-> moveTask config.temp.client.glob, config.dist.app.client.dir, 'moved .temp files to client root'
			-> delTask globs.del.temp.dir, 'deleted .temp directory'
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}cleanup-client", ->
		runTasks()


