# BUILD CLIENT FILES
# client:
#	styles:  []
#	scripts: []
# ===================
module.exports = (gulp, config) ->
	q           = require 'q'
	path        = require 'path'
	gs          = require 'glob-stream'
	rename      = require 'gulp-rename'
	template    = require 'gulp-template'
	pathHelp    = require "#{config.req.helpers}/path"
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"
	format      = require("#{config.req.helpers}/format")()
	data        = client: styles:[], scripts:[]
	globs       = null

	# task
	# ====
	buildFile = (src, dest, file, files) ->
		defer = q.defer()
		gulp.src src
			.pipe rename file
			.pipe template { files }
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log 'files.json built'.yellow
				clearData() # todo, optimize this
				defer.resolve()
		defer.promise

	# for watch events: add and unlink
	# ================================
	clearData = ->
		data.client.styles  = []
		data.client.scripts = []

	# globs
	# =====
	getExcludes = (appOrRb, type, glob) ->
		spaExcludes = config.exclude[appOrRb].from.spaFile[type]
		return glob if not spaExcludes.length
		glob = glob.concat spaExcludes
		# log.json glob, "#{appOrRb} #{type}"
		glob

	getImportExcludes = (appOrRb, type, glob) ->
		imports = config.internal.getImportsAppOrRb appOrRb, true
		return glob unless imports.length
		glob = glob.concat imports
		# log.json glob, "#{appOrRb} #{type}"
		glob

	getGlob = (appOrRb, type, lang) ->
		glob = config.glob.dist[appOrRb].client[type][lang]
		glob = getExcludes appOrRb, type, glob
		glob = getImportExcludes appOrRb, type, glob if lang is 'css'
		glob

	setGlobs = ->
		globs =
			css:
				rb:  getGlob 'rb',  'styles', 'css'
				app: getGlob 'app', 'styles', 'css'
			js:
				rb:  getGlob 'rb',  'scripts', 'js'
				app: getGlob 'app', 'scripts', 'js'

	# helpers
	# =======
	processFiles = (files) ->
		appDir = pathHelp.format(config.app.dir) + '/'
		files.forEach (v, i) ->
			files[i] = pathHelp.format(files[i]).replace appDir, ''
		files

	addData = (type, files) ->
		files = processFiles files
		files.forEach (v, i) ->
			data.client[type].push v

	getFiles = (type, glob) ->
		files  = []
		defer  = q.defer()
		opts   = allowEmpty: true
		stream = gs.create glob, opts
		stream.on 'data', (file) ->
			files.push pathHelp.format file.path
		.on 'end', ->
			addData type, files
			defer.resolve()
		defer.promise

	getAllFiles = (type, lang) -> # sync
		tasks    = []
		defer    = q.defer()
		appAndRb = Object.keys globs[lang]

		appAndRb.forEach (appOrRb) ->
			tasks.push ->
				getFiles type, globs[lang][appOrRb]

		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	buildData = -> # async
		defer = q.defer()
		setGlobs()
		q.all([
			getAllFiles 'styles', 'css'
			getAllFiles 'scripts', 'js'
		]).done -> defer.resolve()
		defer.promise

	# main task
	# =========
	runTask = -> # sync
		defer = q.defer()
		tasks = [
			-> buildData()
			-> buildFile(
				config.templates.files.src.path
				config.templates.files.dest.dir
				config.templates.files.dest.file
				format.json data
			)
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# task deps
	# =========
	taskDeps = ["#{config.rb.prefix.task}clean-files"]

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-files", taskDeps, ->
		return promiseHelp.get() unless config.build.client
		runTask()


