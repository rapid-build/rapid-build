module.exports = (config, gulp, Task) ->
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
		tasks = []
		for file, i in Blueprint[type]
			continue if file.type is 'exclude'
			do (file) ->
				tasks.push ->
					defer = q.defer()
					src   = file.files
					dest  = config.temp.client[type].dir
					gulp.src src
						.on 'error', (e) -> defer.reject e
						.pipe concat file.name
						.pipe gulp.dest dest
						.on 'end', ->
							fileType = if type is 'styles' then 'css' else 'js'
							message  = "concatenated #{fileType} files to create #{file.name} in: #{config.dist.app.client.dir}"
							log.task message
							defer.resolve { message }
					defer.promise
		tasks.reduce(q.when, q()).then ->
			message: "concatenated client: #{type}"

	# Multi Tasks
	# ===========
	setBlueprint = ->
		file      = config.generated.pkg.files.prodFilesBlueprint
		Blueprint = require file
		promiseHelp.get()

	cleanTask = ->
		src = [
			config.temp.client['scripts'].dir
			config.temp.client['styles'].dir
		]
		del(src, force:true).then (paths) ->
			message: 'cleaned temp scripts and styles'

	multiConcatTask = ->
		q.all([
			concatTask 'scripts'
			concatTask 'styles'
		]).then ->
			message: "concatenated scripts and styles"

	# API
	# ===
	api =
		runTask: -> # synchronously
			tasks = [
				-> setBlueprint()
				-> cleanTask()
				-> multiConcatTask()
			]
			tasks.reduce(q.when, q()).then ->
				# log: 'minor'
				message: "completed task: #{Task.name}"

	# return
	# ======
	api.runTask()




