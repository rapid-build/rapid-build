module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.extra.compile.enabled[Task.opts.loc].sass

	# requires
	# ========
	q          = require 'q'
	path       = require 'path'
	plumber    = require 'gulp-plumber'
	sass       = require "#{config.req.plugins}/gulp-sass"
	taskRunner = require("#{config.req.helpers}/task-runner") config
	extCss     = '.css'

	runTask = (src, dest, opts={}) ->
		defer   = q.defer()
		srcOpts = base: opts.base
		gulp.src src, srcOpts
			.on 'error', (e) -> defer.reject e
			.pipe plumber()
			.pipe sass().on 'data', (file) ->
				# needed for empty files. without, ext will stay .scss
				ext = path.extname file.relative
				file.path = file.path.replace ext, extCss if ext isnt extCss
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "completed task: #{Task.name}"
		defer.promise

	# API
	# ===
	api =
		runTask: (loc) ->
			promise = taskRunner.async runTask, 'compile', 'sass', [loc], Task
			promise.then ->
				log: true
				message: "compiled extra sass to: #{config.dist.app[loc].dir}"

	# return
	# ======
	api.runTask Task.opts.loc