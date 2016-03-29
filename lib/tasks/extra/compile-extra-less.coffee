module.exports = (config, gulp, taskOpts={}) ->
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

	# API
	# ===
	api =
		runTask: (loc) ->
			extraHelp.run.tasks.async runTask, 'compile', 'less', [loc]

	# return
	# ======
	api.runTask taskOpts.loc