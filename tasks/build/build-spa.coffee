module.exports = (gulp, config) ->
	q           = require 'q'
	path        = require 'path'
	del         = require 'del'
	gulpif      = require 'gulp-if'
	rename      = require 'gulp-rename'
	replace     = require 'gulp-replace'
	template    = require 'gulp-template'
	pathHelp    = require "#{config.req.helpers}/path"
	moduleHelp  = require "#{config.req.helpers}/module"
	promiseHelp = require "#{config.req.helpers}/promise"
	format      = require("#{config.req.helpers}/format")()
	dirHelper   = require("#{config.req.helpers}/dir") config

	# helpers
	# =======
	runReplace = (type) ->
		newKey       = "<%= #{type} %>"
		key          = "<!--#include #{type}-->"
		placeholders = config.spa.placeholders
		replacePH    = true # PH = placeholder
		if placeholders.indexOf('all') isnt -1
			replacePH = false
		else if placeholders.indexOf(type) isnt -1
			replacePH = false
		gulpif replacePH, replace key, newKey

	# task
	# ====
	buildTask = (src, dest, file, data={}) ->
		defer = q.defer()
		gulp.src src
			.pipe rename file
			.pipe runReplace 'description'
			.pipe runReplace 'moduleName'
			.pipe runReplace 'scripts'
			.pipe runReplace 'styles'
			.pipe runReplace 'title'
			.pipe template data
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log "#{file} built".yellow
				defer.resolve()
		defer.promise

	delCustomSpaTask = ->
		return promiseHelp.get() unless config.spa.custom
		defer = q.defer()
		src   = config.spa.dist.custom.path
		del src, force:true, (e) ->
			emptyDirs = dirHelper.get.emptyDirs(
							config.dist.app.client.dir
							[], 'reverse'
						)
			return defer.resolve() unless emptyDirs.length
			del emptyDirs, force:true, (e) ->
				defer.resolve()
		defer.promise

	# helpers
	# =======
	getFilesJson = (jsonEnvFile) ->
		jsonEnvFile = path.join config.templates.files.dest.dir, jsonEnvFile
		moduleHelp.cache.delete jsonEnvFile
		files = require(jsonEnvFile).client
		files = pathHelp.removeLocPartial files, config.dist.app.client.dir
		files.styles  = format.paths.to.html files.styles, 'styles', join: true, lineEnding: '\n\t'
		files.scripts = format.paths.to.html files.scripts, 'scripts', join: true, lineEnding: '\n\t'
		files

	getData = (jsonEnvFile) ->
		files = getFilesJson jsonEnvFile
		data =
			scripts:     files.scripts
			styles:      files.styles
			moduleName:  config.angular.moduleName
			title:       config.spa.title
			description: config.spa.description

	# main task
	# =========
	runTask = (data={}) -> # synchronously
		defer = q.defer()
		tasks = [
			-> buildTask(
				config.spa.src.path
				config.dist.app.client.dir
				config.spa.dist.file
				data
			)
			# -> delCustomSpaTask()
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register tasks
	# ==============
	gulp.task "#{config.rb.prefix.task}build-spa", ->
		runTask getData 'files.json'

	gulp.task "#{config.rb.prefix.task}build-spa:prod", ->
		runTask getData 'prod-files.json'

