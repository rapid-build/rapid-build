module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	coffee       = require 'gulp-coffee'
	plumber      = require 'gulp-plumber'
	log          = require "#{config.req.helpers}/log"
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
			promise = tasks.run.async runTask, 'scripts', 'coffee', [loc]
			promise.done ->
				log.task "compiled coffee to: #{config.dist.app[loc].dir}"
			promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti taskOpts.loc