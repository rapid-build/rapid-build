module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	log          = require "#{config.req.helpers}/log"
	tasks        = require("#{config.req.helpers}/tasks") config
	forWatchFile = !!taskOpts.watchFile

	runTask = (src, dest, opts={}) ->
		defer = q.defer()
		gulp.src src
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runSingle: ->
			runTask taskOpts.watchFile.path, taskOpts.watchFile.rbDistDir

		runMulti: (loc) ->
			promise = tasks.run.async runTask, 'scripts', 'js', [loc]
			promise.done ->
				log.task "copied js to: #{config.dist.app[loc].dir}"
			promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti taskOpts.loc