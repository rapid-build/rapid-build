module.exports = (gulp, config) ->
	q         = require 'q'
	less      = require 'gulp-less'
	plumber   = require 'gulp-plumber'
	extraHelp = require("#{config.req.helpers}/extra") config

	runTask = (src, dest, base, appOrRb, loc) ->
		defer = q.defer()
		gulp.src src, { base }
			.pipe plumber()
			.pipe less()
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "compiled extra less to #{appOrRb} #{loc}".yellow
				defer.resolve()
		defer.promise

	runTasks = ->
		locs = config.build.getLocs()
		extraHelp.run.tasks.async runTask, 'compile', 'less', locs

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}compile-extra-less", ->
		runTasks()