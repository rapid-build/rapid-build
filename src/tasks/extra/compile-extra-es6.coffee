module.exports = (config, gulp, taskOpts={}) ->
	q         = require 'q'
	babel     = require 'gulp-babel'
	plumber   = require 'gulp-plumber'
	log       = require "#{config.req.helpers}/log"
	extraHelp = require("#{config.req.helpers}/extra") config

	runTask = (src, dest, base, appOrRb, loc) ->
		defer = q.defer()
		gulp.src src, { base }
			.pipe plumber()
			.pipe babel()
			.pipe gulp.dest dest
			.on 'end', ->
				log.task "compiled extra es6 to: #{config.dist.app[loc].dir}"
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: (loc) ->
			extraHelp.run.tasks.async runTask, 'compile', 'es6', [loc]

	# return
	# ======
	api.runTask taskOpts.loc