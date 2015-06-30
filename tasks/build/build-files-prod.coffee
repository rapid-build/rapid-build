module.exports = (gulp, config) ->
	q        = require 'q'
	gs       = require 'glob-stream'
	rename   = require 'gulp-rename'
	template = require 'gulp-template'
	pathHelp = require "#{config.req.helpers}/path"
	format   = require("#{config.req.helpers}/format")()
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
				defer.resolve()
		defer.promise

	# globs
	# =====
	getExcludes = (appOrRb, type, glob) ->
		return glob if not config.spa.exclude[appOrRb][type].length
		glob = glob.concat config.spa.exclude[appOrRb][type]
		glob

	getGlob = (type, lang) ->
		glob = [
			pathHelp.format config.dist.rb.client[type].dir
			pathHelp.format config.dist.app.client[type].dir
		]
		for g, i in glob
			glob[i] += "/**/*.#{lang}"
		glob = getExcludes 'rb',  type, glob
		glob = getExcludes 'app', type, glob
		glob

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
		files = []
		defer = q.defer()
		gs.create(glob).on 'data', (file) ->
			files.push pathHelp.format file.path
		.on 'end', ->
			addData type, files
			defer.resolve()
		defer.promise

	buildData = -> # async
		styles  = getGlob 'styles', 'css'
		scripts = getGlob 'scripts', 'js'
		q.all [
			getFiles 'styles', styles
			getFiles 'scripts', scripts
		]

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-files-prod", ->
		defer = q.defer()
		buildData().done ->
			runTask(
				config.templates.files.src.path
				config.templates.files.dest.dir
				config.templates.files.dest.file
				format.json data
			).done -> defer.resolve()
		defer.promise


