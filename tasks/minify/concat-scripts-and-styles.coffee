module.exports = (config, gulp) ->
	q           = require 'q'
	del         = require 'del'
	path        = require 'path'
	concat      = require 'gulp-concat'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

	# Global Objects
	# ==============
	Blueprint = {}

	# Concat Task
	# ===========
	concatTask = (type) ->
		defer1 = q.defer()
		tasks  = []
		for file, i in Blueprint[type]
			continue if file.type is 'exclude'
			do (file) ->
				tasks.push ->
					defer = q.defer()
					src   = file.files
					dest  = config.temp.client[type].dir
					gulp.src src
						.pipe concat file.name
						.pipe gulp.dest dest
						.on 'end', ->
							console.log "created #{file.name}".yellow
							defer.resolve()
					defer.promise
		tasks.reduce(q.when, q()).done -> defer1.resolve()
		defer1.promise

	# Multi Tasks
	# ===========
	setBlueprint = ->
		file      = path.join config.templates.files.dest.dir, 'prod-files-blueprint.json'
		Blueprint = require file
		promiseHelp.get()

	cleanTask = ->
		defer = q.defer()
		src   = [
			config.temp.client['scripts'].dir
			config.temp.client['styles'].dir
		]
		del(src, force:true).then (paths) ->
			# console.log 'cleaned temp scripts and styles'.yellow
			defer.resolve()
		defer.promise

	multiConcatTask = ->
		defer = q.defer()
		q.all([
			concatTask 'scripts'
			concatTask 'styles'
		]).done -> defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: -> # synchronously
			defer = q.defer()
			tasks = [
				-> setBlueprint()
				-> cleanTask()
				-> multiConcatTask()
			]
			tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()




