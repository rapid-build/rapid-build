module.exports = (config, gulp) ->
	q           = require 'q'
	del         = require 'del'
	path        = require 'path'
	deleteEmpty = require 'delete-empty'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

	# Global Objects
	# ==============
	Blueprint = {}

	# Concat Task
	# ===========
	cleanTask = (type) ->
		defer1 = q.defer()
		tasks  = []
		for file, i in Blueprint[type]
			continue if file.type is 'exclude'
			do (file) ->
				tasks.push ->
					delTask file.files
		tasks.reduce(q.when, q()).done -> defer1.resolve()
		defer1.promise

	# Multi Tasks
	# ===========
	setBlueprint = ->
		file      = config.generated.pkg.files.prodFilesBlueprint
		Blueprint = require file
		promiseHelp.get()

	multiCleanTask = (msg) ->
		defer = q.defer()
		q.all([
			cleanTask 'scripts'
			cleanTask 'styles'
		]).done ->
			# log.task msg, 'minor' if msg
			defer.resolve()
		defer.promise

	cleanCssImportsTask = (msg) ->
		defer = q.defer()
		q.all([
			delTask config.internal.getImportsAppOrRb 'rb'
			delTask config.internal.getImportsAppOrRb 'app'
		]).done ->
			# log.task msg, 'minor' if msg
			defer.resolve()
		defer.promise

	moveTempTask = (msg) ->
		defer = q.defer()
		src   = config.temp.client.glob
		dest  = config.dist.app.client.dir
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				# log.task msg, 'minor' if msg
				defer.resolve()
		defer.promise

	delTask = (src, msg) ->
		defer = q.defer()
		del(src, force:true).then (paths) ->
			# log.task msg, 'minor' if msg
			defer.resolve()
		defer.promise

	delEmptyDirsTask = (msg) ->
		defer = q.defer()
		src   = config.dist.app.client.dir
		opts  = verbose: false
		deleteEmpty src, opts, (err, deleted) ->
			# log.task msg, 'minor' if msg
			defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: -> # synchronously
			defer = q.defer()
			tasks = [
				-> setBlueprint()
				-> multiCleanTask 'cleaned client min files'
				-> cleanCssImportsTask 'cleaned css imports'
				-> moveTempTask 'moved .temp files to client root'
				-> delTask config.temp.client.dir, 'deleted .temp directory'
				-> delEmptyDirsTask 'deleted empty directories'
			]
			tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()




