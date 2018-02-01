module.exports = (config, gulp, Task) ->
	q           = require 'q'
	path        = require 'path'
	fse         = require 'fs-extra'
	log         = require "#{config.req.helpers}/log"
	pathHelp    = require "#{config.req.helpers}/path"
	promiseHelp = require "#{config.req.helpers}/promise"

	# Global Objects
	# ==============
	Blueprint = {}
	ProdFiles = client: scripts: [], styles: []

	# Build Task
	# ==========
	buildTask = ->
		format   = spaces: '\t'
		jsonFile = config.generated.pkg.files.prodFiles
		fse.writeJson(jsonFile, ProdFiles, format).then ->
			message: 'built prod-files.json'

	# Single Tasks
	# ============
	setProdFiles = (type) ->
		files = []
		dir   = config.dist.app.client[type].dir
		for file, i in Blueprint[type]
			if file.type is 'exclude'
				files.push file.files
			else
				minFilePath = path.join dir, file.name
				minFilePath = pathHelp.format minFilePath
				files.push minFilePath
		ProdFiles.client[type] = files
		promiseHelp.get message: "set prod #{type} files"

	# Multi Tasks
	# ===========
	setBlueprint = ->
		file      = config.generated.pkg.files.prodFilesBlueprint
		Blueprint = require file
		promiseHelp.get message: 'set blueprint'

	setMultiProdFiles = ->
		q.all([
			setProdFiles 'scripts'
			setProdFiles 'styles'
		]).then -> message: 'set multi prod files'

	# API
	# ===
	api =
		runTask: -> # synchronously
			tasks = [
				-> setBlueprint()
				-> setMultiProdFiles()
				-> buildTask()
			]
			tasks.reduce(q.when, q()).then ->
				# log.json Blueprint, 'prod files blueprint ='
				# log.json ProdFiles, 'prod files ='
				# log: 'minor'
				message: 'built prod-files.json'

	# return
	# ======
	api.runTask()




