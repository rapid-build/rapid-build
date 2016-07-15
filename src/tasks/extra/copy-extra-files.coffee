module.exports = (config, gulp, taskOpts={}) ->
	q         = require 'q'
	log       = require "#{config.req.helpers}/log"
	extraHelp = require("#{config.req.helpers}/extra") config

	runTask = (src, dest, base, appOrRb, loc) ->
		defer = q.defer()
		gulp.src src, { base, buffer: false }
			.pipe gulp.dest dest
			.on 'end', ->
				log.task "copied extra files to: #{config.dist.app[loc].dir}"
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: (loc) ->
			extraHelp.run.tasks.async runTask, 'copy', null, [loc]

	# return
	# ======
	api.runTask taskOpts.loc