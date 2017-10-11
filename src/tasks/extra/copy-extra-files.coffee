module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	log          = require "#{config.req.helpers}/log"
	extraHelp    = require("#{config.req.helpers}/extra") config
	forWatchFile = !!taskOpts.watchFile

	runTask = (src, dest, base, appOrRb, loc) ->
		defer   = q.defer()
		# follow to ensure globs with "**" work properly with symlinks
		srcOpts = { base, buffer: false, follow: true }
		gulp.src src, srcOpts
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runSingle: ->
			appOrRb = taskOpts.watchFile.rbAppOrRb
			loc     = taskOpts.watchFile.rbClientOrServer
			src     = taskOpts.watchFile.path
			dest    = config.dist[appOrRb][loc].root.dir
			base    = config.src[appOrRb][loc].root.dir
			# log.json { loc, appOrRb, src, base, dest }, 'WATCH EXTRA COPY:'
			runTask src, dest, base, appOrRb, loc

		runMulti: (loc) ->
			promise = extraHelp.run.tasks.async runTask, 'copy', null, [loc]
			promise.done ->
				log.task "copied extra files to: #{config.dist.app[loc].dir}"
			promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti taskOpts.loc