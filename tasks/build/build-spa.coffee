module.exports = (gulp, config) ->
	q          = require 'q'
	template   = require 'gulp-template'
	pathHelp   = require "#{config.req.helpers}/path"
	moduleHelp = require "#{config.req.helpers}/module"

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
		moduleHelp.cache.delete config.json.files.path
		files = require(config.json.files.path).client
		files = pathHelp.removeLocPartial files, config.dist.app.client.dir
		files

	getData = ->
		files = getFilesJson()
		data =
			scripts:     files.scripts
			styles:      files.styles
			moduleName:  config.angular.moduleName
			title:       config.spaFile.title
			description: config.spaFile.description

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-spa", ->
		data = getData()
		runTask(
			config.src.rb.client.spa.path
			config.dist.app.client.dir
			data
		)

