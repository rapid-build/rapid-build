module.exports = (config, gulp) ->
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
		defer    = q.defer()
		format   = spaces: '\t'
		jsonFile = config.generated.pkg.files.prodFiles
		fse.writeJson jsonFile, ProdFiles, format, (e) ->
			console.log 'built prod-files.json'.yellow
			defer.resolve()
		defer.promise

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
		promiseHelp.get()

	# Multi Tasks
	# ===========
	setBlueprint = ->
		file      = config.generated.pkg.files.prodFilesBlueprint
		Blueprint = require file
		promiseHelp.get()

	setMultiProdFiles = ->
		defer = q.defer()
		q.all([
			setProdFiles 'scripts'
			setProdFiles 'styles'
		]).done -> defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: -> # synchronously
			defer = q.defer()
			tasks = [
				-> setBlueprint()
				-> setMultiProdFiles()
				-> buildTask()
			]
			tasks.reduce(q.when, q()).done ->
				# log.json Blueprint, 'prod files blueprint ='
				# log.json ProdFiles, 'prod files ='
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()




