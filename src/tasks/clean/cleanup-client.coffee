module.exports = (config, gulp, Task) ->
	q           = require 'q'
	del         = require 'del'
	deleteEmpty = require 'delete-empty'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

	# Global Objects
	# ==============
	Blueprint = {}

	# Concat Task
	# ===========
	cleanTask = (type) ->
		tasks = []
		for file, i in Blueprint[type]
			continue if file.type is 'exclude'
			do (file) ->
				tasks.push ->
					delTask file.files
		tasks.reduce(q.when, q()).then ->
			message: "cleaned up client #{type} files"

	# Multi Tasks
	# ===========
	setBlueprint = ->
		file      = config.generated.pkg.files.prodFilesBlueprint
		Blueprint = require file
		promiseHelp.get message: 'set blueprint'

	multiCleanTask = (msg) ->
		q.all([
			cleanTask 'scripts'
			cleanTask 'styles'
		]).then ->
			# log.task msg, 'minor' if msg
			message: msg

	cleanCssImportsTask = (msg) ->
		q.all([
			delTask config.internal.getImportsAppOrRb 'rb'
			delTask config.internal.getImportsAppOrRb 'app'
		]).then ->
			# log.task msg, 'minor' if msg
			message: msg

	moveTempTask = (msg) ->
		defer   = q.defer()
		src     = config.temp.client.glob
		dest    = config.dist.app.client.dir
		srcOpts = base: config.temp.client.dir
		gulp.src src, srcOpts
			.on 'error', (e) -> defer.reject e
			.pipe gulp.dest dest
			.on 'end', ->
				# log.task msg, 'minor' if msg
				defer.resolve message: msg
		defer.promise

	delTask = (src, msg) ->
		del(src, force:true).then (paths) ->
			# log.task msg, 'minor' if msg
			message: msg

	delEmptyDirsTask = (msg) ->
		defer = q.defer()
		src   = config.dist.app.client.dir
		opts  = verbose: false
		deleteEmpty src, opts, (err, deleted) ->
			# log.task msg, 'minor' if msg
			defer.resolve message: msg
		defer.promise

	# API
	# ===
	api =
		runTask: -> # synchronously
			tasks = [
				-> setBlueprint()
				-> multiCleanTask 'cleaned client min files'
				-> cleanCssImportsTask 'cleaned css imports'
				-> moveTempTask 'moved .temp files to client root'
				-> delTask config.temp.client.dir, 'deleted .temp directory'
				-> delEmptyDirsTask 'deleted empty directories'
			]
			tasks.reduce(q.when, q()).then ->
				# log: 'minor'
				message: 'cleaned up client directory'

	# return
	# ======
	api.runTask()




