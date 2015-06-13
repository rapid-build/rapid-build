module.exports = (gulp, config) ->
	q          = require 'q'
	gulpif     = require 'gulp-if'
	rename     = require 'gulp-rename'
	replace    = require 'gulp-replace'
	template   = require 'gulp-template'
	pathHelp   = require "#{config.req.helpers}/path"
	moduleHelp = require "#{config.req.helpers}/module"
	format     = require("#{config.req.helpers}/format")()

	# helpers
	# =======
	runReplace = (type) ->
		newKey  = "<%= #{type} %>"
		key     = "<!--#include #{type}-->"
		exclude = config.spa.exclude[type]
		gulpif not exclude, replace key, newKey

	# task
	# ====
	runTask = (src, dest, file, data={}) ->
		defer = q.defer()
		gulp.src src
			.pipe rename file
			.pipe runReplace 'styles'
			.pipe runReplace 'scripts'
			.pipe runReplace 'moduleName'
			.pipe runReplace 'title'
			.pipe runReplace 'description'
			.pipe template data
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log "#{file} built".yellow
				defer.resolve()
		defer.promise

	# helpers
	# =======
	getFilesJson = ->
		moduleHelp.cache.delete config.templates.files.dest.path
		files = require(config.templates.files.dest.path).client
		files = pathHelp.removeLocPartial files, config.dist.app.client.dir
		files.styles  = format.paths.to.html files.styles, 'styles', join: true, lineEnding: '\n\t'
		files.scripts = format.paths.to.html files.scripts, 'scripts', join: true, lineEnding: '\n\t'
		files

	getData = ->
		files = getFilesJson()
		data =
			scripts:     files.scripts
			styles:      files.styles
			moduleName:  config.angular.moduleName
			title:       config.spa.title
			description: config.spa.description

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-spa", ->
		data = getData()
		runTask(
			config.spa.src.path
			config.dist.app.client.dir
			config.spa.dist.file
			data
		)

