module.exports = (gulp, config) ->
	q         = require 'q'
	extraHelp = require("#{config.req.helpers}/extra") config

	runTask = (src, dest, base, appOrRb, loc) ->
		defer = q.defer()
		gulp.src src, { base, buffer: false }
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "copied extra files to #{appOrRb} #{loc}".yellow
				defer.resolve()
		defer.promise

	runTasks = ->
		locs = config.build.getLocs()
		extraHelp.run.tasks.async runTask, 'copy', null, locs

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}copy-extra-files", ->
		runTasks()