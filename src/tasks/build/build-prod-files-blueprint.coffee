module.exports = (config, gulp, Task) ->
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
		format   = spaces: '\t'
		jsonFile = config.generated.pkg.files.prodFilesBlueprint
		fse.writeJson(jsonFile, MinFiles, format).then ->
			message: 'built prod-files-blueprint.json'

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
			.on 'error', (e) -> defer.reject e
			.on 'data', (file) ->
				_path = pathHelp.format(file.path).replace "#{appDir}/", ''
				MinFileExcludes[type].push _path
			.on 'end', ->
				defer.resolve message: "set min #{type} excludes"
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
		promiseHelp.get message: "set min #{type} files"

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
		promiseHelp.get message: "cleaned up min #{type} files"

	# Multi Tasks
	# ===========
	setDevFiles = ->
		files    = require config.generated.pkg.files.files
		DevFiles =
			scripts: files.client.scripts
			styles:  files.client.styles
		promiseHelp.get message: 'set dev files'

	setMultiMinFileExcludes = ->
		q.all([
			setMinFileExcludes 'scripts'
			setMinFileExcludes 'styles'
		]).then -> message: 'set all multi min file excludes'

	setMultiMinFiles = ->
		q.all([
			setMinFiles 'scripts'
			setMinFiles 'styles'
		]).then -> message: 'set all multi min files'

	setMultiMinFilesCleanup = ->
		q.all([
			setMinFilesCleanup 'scripts'
			setMinFilesCleanup 'styles'
		]).then -> message: 'cleaned up all multi min files'

	# API
	# ===
	api =
		runTask: -> # synchronously
			tasks = [
				-> setDevFiles()
				-> setMultiMinFileExcludes()
				-> setMultiMinFiles()
				-> setMultiMinFilesCleanup()
				-> buildTask()
			]
			tasks.reduce(q.when, q()).then ->
				# log.json DevFiles, 'dev files ='
				# log.json MinFileExcludes, 'min file excludes ='
				# log.json MinFiles, 'min files ='
				# log: 'minor'
				message: 'built prod-files-blueprint.json'
	# return
	# ======
	api.runTask()




