module.exports = (config, gulp) ->
	q           = require 'q'
	path        = require 'path'
	fse         = require 'fs-extra'
	log         = require "#{config.req.helpers}/log"
	pathHelp    = require "#{config.req.helpers}/path"
	promiseHelp = require "#{config.req.helpers}/promise"

	# Global Objects
	# ==============
	DevFiles        = {}
	MinFileExcludes = scripts: [], styles: []
	MinFiles        = scripts: [], styles: []

	# Build Task
	# ==========
	buildTask = ->
		defer    = q.defer()
		format   = spaces: '\t'
		jsonFile = config.generated.pkg.files.prodFilesBlueprint
		fse.writeJson jsonFile, MinFiles, format, (e) ->
			# log.task 'built prod-files-blueprint.json', 'minor'
			defer.resolve()
		defer.promise

	# Single Tasks
	# ============
	setMinFileExcludes = (type) ->
		defer   = q.defer()
		appDir  = pathHelp.format config.app.dir
		srcOpts = buffer: false, allowEmpty: true
		src = [].concat(
			config.exclude.rb.from.minFile[type]
			config.exclude.app.from.minFile[type]
		)
		return promiseHelp.get defer unless src.length
		gulp.src src, srcOpts
			.on 'data', (file) ->
				_path = pathHelp.format(file.path).replace "#{appDir}/", ''
				MinFileExcludes[type].push _path
			.on 'end', ->
				defer.resolve()
		defer.promise

	setMinFiles = (type) ->
		cnt     = 0
		minCnt  = 0
		exclude = false
		ext     = if type is 'scripts' then 'js' else 'css'
		for file in DevFiles[type]
			if MinFileExcludes[type].indexOf(file) isnt -1
				cnt++
				exclude = true
				MinFiles[type].push(
					cnt:  cnt
					type: 'exclude'
					name:  null
					files: file
				)
			else
				if exclude or not cnt
					cnt++
					minCnt++
					exclude = false
					fileName = path.basename config.fileName[type].min, ".#{ext}"
					MinFiles[type].push(
						cnt:   cnt
						type:  'include'
						name:  "#{fileName}.#{minCnt}.#{ext}"
						files: []
					)
				MinFiles[type][cnt-1].files.push file
		promiseHelp.get()

	setMinFilesCleanup = (type) ->
		ext      = if type is 'scripts' then 'js' else 'css'
		includes = total: 0, index: undefined
		for file, i in MinFiles[type]
			if file.type is 'include'
				includes.total++
				break if includes.total > 1
				includes.index = i
			# console.log file.type
		return promiseHelp.get() unless includes.total is 1
		MinFiles[type][includes.index].name = config.fileName[type].min
		promiseHelp.get()

	# Multi Tasks
	# ===========
	setDevFiles = ->
		files    = require config.generated.pkg.files.files
		DevFiles =
			scripts: files.client.scripts
			styles:  files.client.styles
		promiseHelp.get()

	setMultiMinFileExcludes = ->
		defer = q.defer()
		q.all([
			setMinFileExcludes 'scripts'
			setMinFileExcludes 'styles'
		]).done -> defer.resolve()
		defer.promise

	setMultiMinFiles = ->
		defer = q.defer()
		q.all([
			setMinFiles 'scripts'
			setMinFiles 'styles'
		]).done -> defer.resolve()
		defer.promise

	setMultiMinFilesCleanup = ->
		defer = q.defer()
		q.all([
			setMinFilesCleanup 'scripts'
			setMinFilesCleanup 'styles'
		]).done -> defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: -> # synchronously
			defer = q.defer()
			tasks = [
				-> setDevFiles()
				-> setMultiMinFileExcludes()
				-> setMultiMinFiles()
				-> setMultiMinFilesCleanup()
				-> buildTask()
			]
			tasks.reduce(q.when, q()).done ->
				# log.json DevFiles, 'dev files ='
				# log.json MinFileExcludes, 'min file excludes ='
				# log.json MinFiles, 'min files ='
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()




