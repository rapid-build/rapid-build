module.exports = (gulp, config) ->
	q        = require 'q'
	rename   = require 'gulp-rename'
	template = require 'gulp-template'
	format   = require "#{config.req.helpers}/format"

	runTask = (src, dest, file, data) ->
		defer = q.defer()
		gulp.src src
			.pipe rename file
			.pipe template config: data
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log 'config.json built'.yellow
				defer.resolve()
		defer.promise

	# task deps
	# =========
	taskDeps = ["#{config.rb.prefix.task}clean-config"]

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}build-config", taskDeps, ->
		runTask(
			config.json.config.template
			config.json.config.dir
			config.json.config.file
			format.json config
		)