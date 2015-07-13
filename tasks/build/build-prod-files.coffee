module.exports = (gulp, config) ->
	q               = require 'q'
	path            = require 'path'
	rename          = require 'gulp-rename'
	template        = require 'gulp-template'
	log             = require "#{config.req.helpers}/log"
	pathHelp        = require "#{config.req.helpers}/path"
	promiseHelp     = require "#{config.req.helpers}/promise"
	format          = require("#{config.req.helpers}/format")()

	# Global Objects
	# ==============
	Blueprint = {}
	ProdFiles = client: scripts: [], styles: []

	# Build Task
	# ==========
	buildTask = ->
		src  = path.join config.templates.dir, 'prod-files.tpl'
		dest = config.templates.files.dest.dir
		file = 'prod-files.json'
		data = format.json ProdFiles
		defer = q.defer()
		gulp.src src
			.pipe rename file
			.pipe template prodFiles: data
			.pipe gulp.dest dest
			.on 'end', ->
				console.log 'prod-files.json built'.yellow
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
		file      = path.join config.templates.files.dest.dir, 'prod-files-blueprint.json'
		Blueprint = require file
		promiseHelp.get()

	setMultiProdFiles = ->
		defer = q.defer()
		q.all([
			setProdFiles 'scripts'
			setProdFiles 'styles'
		]).done -> defer.resolve()
		defer.promise

	# Main Task
	# =========
	runTask = -> # synchronously
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

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-prod-files", ->
		runTask()




