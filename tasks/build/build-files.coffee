module.exports = (gulp, config) ->
	q        = require 'q'
	path     = require 'path'
	gs       = require 'glob-stream'
	rename   = require 'gulp-rename'
	template = require 'gulp-template'
	pathHelp = require "#{config.req.helpers}/path"
	data     = client: styles:[], scripts:[]

	# task
	# ====
	runTask = (src, dest, file, files) ->
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
	getGlob = (loc, type, lang) ->
		config.glob.dist[loc].client[type][lang]

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
		locDir = pathHelp.format(config.app.dir) + '/'
		files.forEach (v, i) ->
			files[i] = pathHelp.format(files[i]).replace locDir, ''
		files

	addData = (type, files) ->
		files = processFiles files
		files.forEach (v, i) ->
			data.client[type].push v

	getFiles = (type, glob) ->
		files = []
		defer = q.defer()
		gs.create(glob).on 'data', (file) ->
			files.push pathHelp.format file.path
		.on 'end', ->
			addData type, files
			defer.resolve()
		defer.promise

	getAllFiles = (type, lang) -> # sync
		tasks = []
		defer = q.defer()
		locs  = Object.keys globs[lang]

		locs.forEach (loc) ->
			tasks.push ->
				getFiles type, globs[lang][loc]

		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	buildData = -> # async
		q.all [
			getAllFiles 'styles', 'css'
			getAllFiles 'scripts', 'js'
		]

	# task deps
	# =========
	taskDeps = ["#{config.rb.prefix.task}clean-files"]

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-files", taskDeps, ->
		defer = q.defer()
		buildData().done ->
			runTask(
				config.json.files.template
				config.json.files.dir
				config.json.files.file
				JSON.stringify data, null, '\t'
			).done -> defer.resolve()
		defer.promise


