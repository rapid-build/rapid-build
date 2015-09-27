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

	runTasks = (loc) ->
		extraHelp.run.tasks.async runTask, 'compile', 'less', [loc]

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}compile-extra-less:client", ->
		runTasks 'client'

	gulp.task "#{config.rb.prefix.task}compile-extra-less:server", ->
		runTasks 'server'