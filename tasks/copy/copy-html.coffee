module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	gulpif       = require 'gulp-if'
	ngFormify    = require "#{config.req.plugins}/gulp-ng-formify"
	tasks        = require("#{config.req.helpers}/tasks") config
	runNgFormify = config.angular.ngFormify
	forWatchFile = !!taskOpts.watchFile

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulpif runNgFormify, ngFormify()
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

		runMulti: ->
			tasks.run.async runTask, 'views', 'html', ['client']

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()