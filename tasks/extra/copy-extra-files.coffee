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

	runTasks = (loc) ->
		extraHelp.run.tasks.async runTask, 'copy', null, [loc]

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}copy-extra-files:client", ->
		runTasks 'client'

	gulp.task "#{config.rb.prefix.task}copy-extra-files:server", ->
		runTasks 'server'