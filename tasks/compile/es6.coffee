module.exports = (config, gulp, taskOpts={}) ->
	q             = require 'q'
	babel         = require 'gulp-babel'
	plumber       = require 'gulp-plumber'
	es2015        = require 'babel-preset-es2015'
	tasks         = require("#{config.req.helpers}/tasks") config
	forWatchFile  = !!taskOpts.watchFile
	babelOpts     = presets: [es2015]

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe plumber()
			.pipe babel babelOpts
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
			tasks.run.async runTask, 'scripts', 'es6', [loc]

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti taskOpts.loc