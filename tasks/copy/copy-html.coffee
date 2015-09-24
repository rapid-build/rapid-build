module.exports = (gulp, config, watchFile={}) ->
	q            = require 'q'
	gulpif       = require 'gulp-if'
	promiseHelp  = require "#{config.req.helpers}/promise"
	ngFormify    = require "#{config.req.plugins}/gulp-ng-formify"
	tasks        = require("#{config.req.helpers}/tasks")()
	runNgFormify = config.angular.ngFormify
	forWatchFile = !!watchFile.path

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe gulpif runNgFormify, ngFormify()
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	runSingle = ->
		runTask watchFile.path, watchFile.rbDistDir

	runMulti = ->
		tasks.run.async(
			config, runTask,
			'views', 'html',
			['client']
		)

	# register task
	# =============
	return runSingle() if forWatchFile
	gulp.task "#{config.rb.prefix.task}copy-html", ->
		return promiseHelp.get() unless config.build.client
		runMulti()