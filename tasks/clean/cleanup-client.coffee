module.exports = (gulp, config) ->
	q           = require 'q'
	del         = require 'del'
	path        = require 'path'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"
	dirHelper   = require("#{config.req.helpers}/dir") config

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
		file      = path.join config.templates.files.dest.dir, 'prod-files-blueprint.json'
		Blueprint = require file
		promiseHelp.get()

	multiCleanTask = (msg) ->
		defer = q.defer()
		q.all([
			cleanTask 'scripts'
			cleanTask 'styles'
		]).done ->
			console.log msg.yellow if msg
			defer.resolve()
		defer.promise

	moveTempTask = (msg) ->
		defer = q.defer()
		src   = config.temp.client.glob
		dest  = config.dist.app.client.dir
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				console.log msg.yellow if msg
				defer.resolve()
		defer.promise

	delTask = (src, msg) ->
		defer = q.defer()
		del src, force:true, ->
			console.log msg.yellow if msg
			defer.resolve()
		defer.promise

	delEmptyDirsTask = (msg) ->
		emptyDirs = dirHelper.get.emptyDirs(
						config.dist.app.client.dir
						[], 'reverse'
					)
		return promiseHelp.get() if not emptyDirs.length
		delTask emptyDirs, msg

	# Main Task
	# =========
	runTask = -> # synchronously
		defer = q.defer()
		tasks = [
			-> setBlueprint()
			-> multiCleanTask 'cleaned client min files'
			-> moveTempTask 'moved .temp files to client root'
			-> delTask config.temp.client.dir, 'deleted .temp directory'
			-> delEmptyDirsTask 'deleted empty directories'
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}cleanup-client", ->
		runTask()




