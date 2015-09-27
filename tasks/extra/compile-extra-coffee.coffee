module.exports = (gulp, config) ->
	q         = require 'q'
	coffee    = require 'gulp-coffee'
	plumber   = require 'gulp-plumber'
	extraHelp = require("#{config.req.helpers}/extra") config

	runTask = (src, dest, base, appOrRb, loc) ->
		defer = q.defer()
		gulp.src src, { base }
			.pipe plumber()
			.pipe coffee bare: true
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "compiled extra coffee to #{appOrRb} #{loc}".yellow
				defer.resolve()
		defer.promise

	runTasks = (loc) ->
		extraHelp.run.tasks.async runTask, 'compile', 'coffee', [loc]

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}compile-extra-coffee:client", ->
		runTasks 'client'