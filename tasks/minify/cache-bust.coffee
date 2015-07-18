module.exports = (gulp, config) ->
	q              = require 'q'
	del            = require 'del'
	path           = require 'path'
	Bust           = require 'gulp-cachebust'
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
				console.log 'file names busted'.yellow
				defer.resolve()
		defer.promise

	runDelUnstampedPaths = ->
		defer = q.defer()
		return promiseHelp.get defer if not unstampedPaths.length
		del unstampedPaths, force:true, (e) ->
			# console.log 'unstamped files deleted'.yellow
			defer.resolve()
		defer.promise

	runStampRefs = (src, dest, bust) ->
		defer = q.defer()
		gulp.src src
			.pipe bust.references()
			.pipe gulp.dest dest
			.on 'end', ->
				console.log 'file references busted'.yellow
				defer.resolve()
		defer.promise

	runCacheBustTask = -> # synchronously
		defer         = q.defer()
		bust          = new Bust bustOpts
		srcFiles      = config.glob.dist.app.client.cacheBust.files
		srcRefs       = config.glob.dist.app.client.cacheBust.references
		dest          = config.dist.app.client.dir
		prodFilesSrc  = path.join config.templates.files.dest.dir, 'prod-files.json'
		prodFilesDest = config.templates.files.dest.dir
		tasks = [
			-> runStampFiles srcFiles, dest, bust
			-> runStampRefs srcRefs, dest, bust
			-> runStampRefs prodFilesSrc, prodFilesDest, bust
			-> runDelUnstampedPaths()
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}cache-bust", ->
		return promiseHelp.get() if not config.minify.cacheBust
		runCacheBustTask()


