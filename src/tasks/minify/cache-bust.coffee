module.exports = (config, gulp) ->
	q              = require 'q'
	del            = require 'del'
	path           = require 'path'
	Bust           = require 'gulp-cachebust' # might try gulp-bust
	log            = require "#{config.req.helpers}/log"
	promiseHelp    = require "#{config.req.helpers}/promise"
	unstampedPaths = []
	bustOpts =
		checksumLength: 3

	# Helpers
	# =======
	getUnstampedPath = (_path) ->
		dir   = path.dirname _path
		ext   = path.extname _path
		name  = path.basename _path, ext # will exclude the ext
		end   = name.length - (bustOpts.checksumLength + 1) # + 1 for the dot
		name  = name.substring(0, end) + ext
		_path = path.join dir, name

	# Tasks
	# =====
	runStampFiles = (src, dest, bust) ->
		defer = q.defer()
		gulp.src src
			.pipe bust.resources()
			.on 'data', (file) ->
				unstampedPaths.push getUnstampedPath file.path
			.pipe gulp.dest dest
			.on 'end', ->
				# log.task 'file names busted', 'minor'
				defer.resolve()
		defer.promise

	runDelUnstampedPaths = ->
		defer = q.defer()
		return promiseHelp.get defer unless unstampedPaths.length
		del(unstampedPaths, force:true).then (paths) ->
			# log.task 'unstamped files deleted', 'minor'
			defer.resolve()
		defer.promise

	runStampRefs = (src, dest, bust) ->
		defer = q.defer()
		gulp.src src
			.pipe bust.references()
			.pipe gulp.dest dest
			.on 'end', ->
				# log.task 'file references busted', 'minor'
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: -> # synchronously
			return promiseHelp.get() unless config.minify.cacheBust
			defer         = q.defer()
			bust          = new Bust bustOpts
			srcFiles      = config.glob.dist.app.client.cacheBust.files
			srcRefs       = config.glob.dist.app.client.cacheBust.references
			dest          = config.dist.app.client.dir
			prodFilesSrc  = config.generated.pkg.files.prodFiles
			prodFilesDest = config.generated.pkg.files.path
			tasks = [
				-> runStampFiles srcFiles, dest, bust
				-> runStampRefs srcRefs, dest, bust
				-> runStampRefs prodFilesSrc, prodFilesDest, bust
				-> runDelUnstampedPaths()
			]
			tasks.reduce(q.when, q()).done ->
				log.task "cache busted files in: #{config.dist.app.client.dir}"
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()


