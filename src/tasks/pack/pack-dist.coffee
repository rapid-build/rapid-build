module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	pack        = config.dist.pack
	return promiseHelp.get() unless pack.enabled

	# requires
	# ========
	q      = require 'q'
	del    = require 'del'
	tar    = require 'gulp-tar'
	zip    = require 'gulp-zip'
	gzip   = require 'gulp-gzip'
	gulpif = require 'gulp-if'

	# Tasks
	# =====
	cleanPack = ->
		opts = force: true
		src  = pack.filePath
		del(src, opts).then (paths) ->
			message: "cleaned #{pack.fileName}"

	packDist = ->
		src      = pack.glob
		dest     = config.app.dir
		base     = pack.base
		fileName = pack.fileName
		defer    = q.defer()
		gulp.src src, { base }
			.on 'error', (e) -> defer.reject e
			.pipe gulpif pack.is.zip, zip fileName
			.pipe gulpif pack.is.tar or pack.is.gzip, tar fileName
			.pipe gulpif pack.is.gzip, gzip append: false
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "completed task: #{Task.name}"
		defer.promise

	# API
	# ===
	api =
		runTask: -> # synchronously
			tasks = [
				-> cleanPack()
				-> packDist()
			]
			tasks.reduce(q.when, q()).then ->
				log: true
				message: "packed: #{pack.fileName}"

	# return
	# ======
	api.runTask()




