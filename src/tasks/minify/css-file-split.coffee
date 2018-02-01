# FOR IE 9 AND BELOW - (for prod build, run against styles.min.css)
# Selector limit per stylesheet: 4,095
# Fortunately IE 10 ups the limit to: 65,534
# If you don't care about those piece of shit browsers, then disable this option.
# ===============================================================================
module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.minify.css.splitMinFile

	# requires
	# ========
	q        = require 'q'
	fs       = require 'fs'
	fse      = require 'fs-extra'
	path     = require 'path'
	bless    = require 'gulp-bless'
	log      = require "#{config.req.helpers}/log"
	pathHelp = require "#{config.req.helpers}/path"

	# Global Objects
	# ==============
	SplitFiles = []
	ProdFiles  = {}

	# tasks
	# =====
	splitTask = (src, dest, ext) ->
		defer = q.defer()
		opts  = imports: false, force: true
		files = []
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.on 'data', (file) ->
				basename = path.basename file.path
				files.push
					cnt: 0,
					name: basename,
					newPaths: []
			.pipe bless opts
			.on 'data', (file) -> # change the name so the glob order will be correct
				total         = files.length
				basename      = file.basename
				return unless total
				return unless basename
				_file         = files[total-1]
				isBlessedFile = basename.indexOf('blessed') isnt -1
				didSplit      = isBlessedFile or _file.cnt
				return unless didSplit
				fs.unlinkSync file.path unless isBlessedFile # remove styles.min.css
				_file.cnt++
				basename      = path.basename _file.name, ext
				file.basename = "#{basename}.#{_file.cnt}#{ext}"
				_file.newPaths.push file.path
			.pipe gulp.dest dest
			.on 'end', ->
				for file in files
					continue unless file.cnt
					SplitFiles.push file
					log.task "split #{file.name} into #{file.cnt} files"
				defer.resolve message: "completed: css split task"
		defer.promise

	updateSplitFiles = ->
		appDir = pathHelp.format config.app.dir
		for file in SplitFiles
			for v, i in file.newPaths
				file.newPaths[i] = pathHelp.format(v).replace "#{appDir}/", ''
		promiseHelp.get "completed: split files update"

	updateProdFiles = ->
		dest      = pathHelp.format config.dist.app.client.styles.dir
		file      = config.generated.pkg.files.prodFiles
		ProdFiles = require file
		styles    = []
		for v1 in ProdFiles.client.styles
			match = false
			for v2 in SplitFiles
				_path  = "#{dest}/#{v2.name}"
				continue unless v1.indexOf(_path) isnt -1
				match  = true
				styles = styles.concat v2.newPaths
				break
			styles.push v1 unless match
		ProdFiles.client.styles = styles
		promiseHelp.get "completed: prod files update"

	buildProdFiles = ->
		format   = spaces: '\t'
		jsonFile = config.generated.pkg.files.prodFiles
		fse.writeJson(jsonFile, ProdFiles, format).then ->
			message: 'rebuilt prod-files.json because of css file split'

	rebuildProdFiles = -> # synchronously
		return promiseHelp.get() unless SplitFiles.length
		tasks = [
			-> updateSplitFiles()
			-> updateProdFiles()
			-> buildProdFiles()
		]
		tasks.reduce(q.when, q()).then ->
			message: "completed: rebuild prod files"

	# API
	# ===
	api =
		runTask: -> # synchronously
			ext      = '.css'
			dest     = config.dist.app.client.styles.dir
			fileName = path.basename config.fileName.styles.min, ext
			src      = path.join dest, "{#{fileName}#{ext},#{fileName}.*#{ext}}"
			tasks = [
				-> splitTask src, dest, ext
				-> rebuildProdFiles()
			]
			tasks.reduce(q.when, q()).then ->
				# log: 'minor'
				message: "completed task: #{Task.name}"

	# return
	# ======
	api.runTask()



