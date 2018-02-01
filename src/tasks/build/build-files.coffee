# BUILD CLIENT FILES
# client:
#	styles:  []
#	scripts: []
# ===================
module.exports = (config, gulp, Task) ->
	q        = require 'q'
	path     = require 'path'
	fse      = require 'fs-extra'
	gs       = require 'glob-stream'
	pathHelp = require "#{config.req.helpers}/path"
	log      = require "#{config.req.helpers}/log"
	data     = client: styles:[], scripts:[]
	globs    = null

	# task
	# ====
	buildFile = (json) ->
		format   = spaces: '\t'
		jsonFile = config.generated.pkg.files.files
		fse.writeJson(jsonFile, json, format).then ->
			message: 'built files.json'

	# for watch events: add and unlink
	# ================================
	clearData = ->
		data.client.styles  = []
		data.client.scripts = []

	# globs
	# =====
	getExcludes = (appOrRb, type, glob) ->
		spaExcludes = config.exclude[appOrRb].from.spaFile[type]
		return glob unless spaExcludes.length
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

	getFiles = (appOrRb, type, glob) ->
		files  = []
		defer  = q.defer()
		opts   = allowEmpty: true
		stream = gs glob, opts
		stream.on 'error', (e) -> defer.reject e
		stream.on 'data', (file) ->
			_path = path.normalize file.path
			_path = pathHelp.format _path
			files.push _path
		.on 'end', ->
			addData type, files
			defer.resolve message: "added #{appOrRb} #{type}"
		defer.promise

	getAllFiles = (type, lang) -> # sync
		tasks    = []
		appAndRb = Object.keys globs[lang]
		appAndRb.forEach (appOrRb) ->
			tasks.push ->
				getFiles appOrRb, type, globs[lang][appOrRb]
		tasks.reduce(q.when, q()).then ->
			message: "added all #{lang} files"

	buildData = -> # async
		setGlobs()
		q.all([
			getAllFiles 'styles', 'css'
			getAllFiles 'scripts', 'js'
		]).then -> message: 'built data'

	addAngularBootstrap = ->
		return if config.exclude.default.client.files
		return if config.exclude.angular.files
		return unless config.angular.bootstrap.enabled
		_path = path.join config.dist.rb.client.dir, 'scripts', 'bootstrap.js'
		_path = pathHelp.format _path
		data.client.scripts.push _path # add last

	# API
	# ===
	api =
		runTask: -> # sync
			tasks = [
				-> buildData()
				-> addAngularBootstrap()
				-> buildFile data
			]
			tasks.reduce(q.when, q()).then ->
				# log: 'minor'
				message: 'built files.json'

	# return
	# ======
	api.runTask()


