module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	coffee       = require 'gulp-coffee'
	plumber      = require 'gulp-plumber'
	tasks        = require("#{config.req.helpers}/tasks") config
	forWatchFile = !!taskOpts.watchFile

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe plumber()
			.pipe coffee bare: true
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
			tasks.run.async runTask, 'scripts', 'coffee', [loc]

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti taskOpts.loc