module.exports = (config, gulp, taskOpts={}) ->
	q           = require 'q'
	fs          = require 'fs'
	path        = require 'path'
	gulpif      = require 'gulp-if'
	replace     = require 'gulp-replace'
	template    = require 'gulp-template'
	log         = require "#{config.req.helpers}/log"
	pathHelp    = require "#{config.req.helpers}/path"
	moduleHelp  = require "#{config.req.helpers}/module"
	format      = require("#{config.req.helpers}/format")()

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
			.pipe runReplace 'clickjacking'
			.pipe runReplace 'description'
			.pipe runReplace 'moduleName'
			.pipe runReplace 'ngCloakStyles'
			.pipe runReplace 'scripts'
			.pipe runReplace 'styles'
			.pipe runReplace 'title'
			.pipe template data
			.pipe gulp.dest dest
			.on 'end', ->
				log.task "built and copied #{file} to: #{config.dist.app.client.dir}"
				defer.resolve()
		defer.promise

	# helpers
	# =======
	getFilesJson = (jsonEnvFile) ->
		jsonEnvFile = path.join config.generated.pkg.files.path, jsonEnvFile
		moduleHelp.cache.delete jsonEnvFile
		removePathSection  = config.dist.app.client.dir
		removePathSection += '/' unless config.dist.client.paths.absolute
		files = require(jsonEnvFile).client
		files = pathHelp.removeLocPartial files, removePathSection
		files.styles  = format.paths.to.html files.styles, 'styles', join: true, lineEnding: '\n\t'
		files.scripts = format.paths.to.html files.scripts, 'scripts', join: true, lineEnding: '\n\t'
		files

	getClickjackingTpl = ->
		return '' unless config.security.client.clickjacking
		fs.readFileSync(config.templates.clickjacking.src.path).toString()

	getNgCloakStylesTpl = ->
		fs.readFileSync(config.templates.ngCloakStyles.src.path).toString()

	getData = (jsonEnvFile) ->
		files = getFilesJson jsonEnvFile
		data =
			clickjacking:  getClickjackingTpl()
			description:   config.spa.description
			moduleName:    config.angular.moduleName
			ngCloakStyles: getNgCloakStylesTpl()
			scripts:       files.scripts
			styles:        files.styles
			title:         config.spa.title

	# API
	# ===
	api =
		runTask: (env) -> # synchronously
			defer = q.defer()
			json  = if env is 'prod' then 'prod-files.json' else 'files.json'
			data  = getData json
			tasks = [
				-> buildTask(
					config.spa.temp.path
					config.dist.app.client.dir
					config.spa.dist.file
					data
				)
			]
			tasks.reduce(q.when, q()).done -> defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask taskOpts.env



