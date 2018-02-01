module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.minify.cacheBust

	# requires
	# ========
	q    = require 'q'
	del  = require 'del'
	path = require 'path'
	Bust = require 'gulp-cachebust' # might try gulp-bust
	log  = require "#{config.req.helpers}/log"
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
			.on 'error', (e) -> defer.reject e
			.pipe bust.resources()
			.on 'data', (file) ->
				unstampedPaths.push getUnstampedPath file.path
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "busted file names"
		defer.promise

	runDelUnstampedPaths = ->
		return promiseHelp.get() unless unstampedPaths.length
		del(unstampedPaths, force:true).then (paths) ->
			message: "deleted unstamped files"

	runStampRefs = (src, dest, bust) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe bust.references()
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "busted file references"
		defer.promise

	# API
	# ===
	api =
		runTask: -> # synchronously
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
			tasks.reduce(q.when, q()).then ->
				log: true
				message: "cache busted files in: #{config.dist.app.client.dir}"

	# return
	# ======
	api.runTask()


