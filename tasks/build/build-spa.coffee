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

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-spa", ->
		moduleHelp.cache.delete config.json.files.path
		files = require(config.json.files.path).client
		files = pathHelp.removeLocPartial files, config.dist.app.client.dir
		runTask(
			config.src.rb.client.spa.path
			config.dist.app.client.dir
			files
		)

