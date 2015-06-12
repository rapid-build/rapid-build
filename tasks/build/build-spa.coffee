module.exports = (gulp, config) ->
	q          = require 'q'
	template   = require 'gulp-template'
	pathHelp   = require "#{config.req.helpers}/path"
	moduleHelp = require "#{config.req.helpers}/module"
	format     = require("#{config.req.helpers}/format")()

	# task
	# ====
	runTask = (src, dest, data={}) ->
		defer = q.defer()
		gulp.src src
			.pipe template data
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log 'spa.html built'.yellow
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
			config.src.rb.client.spa.path
			config.dist.app.client.dir
			data
		)

