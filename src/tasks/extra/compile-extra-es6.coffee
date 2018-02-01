module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.extra.compile.enabled[Task.opts.loc].es6

	# requires
	# ========
	q          = require 'q'
	babel      = require 'gulp-babel'
	plumber    = require 'gulp-plumber'
	taskRunner = require("#{config.req.helpers}/task-runner") config

	runTask = (src, dest, opts={}) ->
		defer   = q.defer()
		srcOpts = base: opts.base
		gulp.src src, srcOpts
			.on 'error', (e) -> defer.reject e
			.pipe plumber()
			.pipe babel()
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "completed task: #{Task.name}"
		defer.promise

	# API
	# ===
	api =
		runTask: (loc) ->
			promise = taskRunner.async runTask, 'compile', 'es6', [loc], Task
			promise.then ->
				log: true
				message: "compiled extra es6 to: #{config.dist.app[loc].dir}"

	# return
	# ======
	api.runTask Task.opts.loc