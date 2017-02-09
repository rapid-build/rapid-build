module.exports = (config, gulp) ->
	q           = require 'q'
	del         = require 'del'
	tar         = require 'gulp-tar'
	zip         = require 'gulp-zip'
	gzip        = require 'gulp-gzip'
	gulpif      = require 'gulp-if'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"
	pack        = config.dist.pack

	# Tasks
	# =====
	cleanPack = ->
		defer = q.defer()
		opts  = force: true
		src   = pack.filePath
		del(src, opts).then (paths) ->
			# log.task "cleaned #{pack.fileName}", 'minor'
			defer.resolve()
		defer.promise

	packDist = ->
		src      = pack.glob
		dest     = config.app.dir
		base     = pack.base
		fileName = pack.fileName
		defer    = q.defer()
		gulp.src src, { base }
			.pipe gulpif pack.is.zip, zip fileName
			.pipe gulpif pack.is.tar or pack.is.gzip, tar fileName
			.pipe gulpif pack.is.gzip, gzip append: false
			.pipe gulp.dest dest
			.on 'end', ->
				# log.task "packed #{fileName}", 'minor'
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: -> # synchronously
			return promiseHelp.get() unless pack.enabled
			defer = q.defer()
			tasks = [
				-> cleanPack()
				-> packDist()
			]
			tasks.reduce(q.when, q()).done ->
				log.task "Packed #{pack.fileName}", 'alert'
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()




