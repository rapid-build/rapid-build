module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFile

	unless forWatchFile
		promiseHelp = require "#{config.req.helpers}/promise"
		return promiseHelp.get() unless config.extra.copy.enabled[Task.opts.loc]

	# requires
	# ========
	q          = require 'q'
	taskRunner = require("#{config.req.helpers}/task-runner") config

	runTask = (src, dest, opts={}) ->
		# follow to ensure globs with "**" work properly with symlinks
		defer   = q.defer()
		srcOpts = base: opts.base, buffer: false, follow: true
		gulp.src src, srcOpts
			.on 'error', (e) -> defer.reject e
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "completed task: #{Task.name}"
		defer.promise

	# API
	# ===
	api =
		runSingle: ->
			appOrRb = Task.opts.watchFile.rbAppOrRb
			loc     = Task.opts.watchFile.rbClientOrServer
			src     = Task.opts.watchFile.path
			dest    = config.dist[appOrRb][loc].root.dir
			base    = config.src[appOrRb][loc].root.dir
			opts    = { appOrRb, loc, base }
			# console.log 'WATCH EXTRA COPY:', { src, dest, opts }
			runTask src, dest, opts

		runMulti: (loc) ->
			promise = taskRunner.async runTask, 'copy', null, [loc], Task
			promise.then ->
				log: true
				message: "copied extra files to: #{config.dist.app[loc].dir}"

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti Task.opts.loc