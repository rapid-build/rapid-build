module.exports = (gulp, config) ->
	q           = require 'q'
	babel       = require 'gulp-babel'
	plumber     = require 'gulp-plumber'
	promiseHelp = require "#{config.req.helpers}/promise"
	extraHelp   = require("#{config.req.helpers}/extra") config

	runTask = (src, dest, base, appOrRb, loc) ->
		defer = q.defer()
		gulp.src src, { base }
			.pipe plumber()
			.pipe babel()
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "compiled extra es6 to #{appOrRb} #{loc}".yellow
				defer.resolve()
		defer.promise

	runTasks = ->
		extraHelp.run.tasks.async runTask, 'compile', 'es6', ['client']

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}compile-extra-es6", ->
		return promiseHelp.get() unless config.build.client
		runTasks()