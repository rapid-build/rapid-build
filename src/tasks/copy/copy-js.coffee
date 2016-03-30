module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	tasks        = require("#{config.req.helpers}/tasks") config
	forWatchFile = !!taskOpts.watchFile

	runTask = (src, dest) ->
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
			tasks.run.async runTask, 'scripts', 'js', [loc]

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti taskOpts.loc