module.exports = (config, gulp, taskOpts={}) ->
	q                  = require 'q'
	gulpif             = require 'gulp-if'
	plumber            = require 'gulp-plumber'
	log                = require "#{config.req.helpers}/log"
	ngFormify          = require "#{config.req.plugins}/gulp-ng-formify"
	compileHtmlScripts = require "#{config.req.plugins}/gulp-compile-html-scripts"
	tasks              = require("#{config.req.helpers}/tasks") config
	runNgFormify       = config.angular.ngFormify
	forWatchFile       = !!taskOpts.watchFile

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe plumber()
			.pipe gulpif runNgFormify, ngFormify()
			.pipe gulpif config.compile.htmlScripts.client.enable, compileHtmlScripts()
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
			promise = tasks.run.async runTask, 'views', 'html', ['client']
			promise.done ->
				log.task "compiled html es6 scripts to: #{config.dist.app.client.dir}" if config.compile.htmlScripts.client.enable
				log.task "copied views to: #{config.dist.app.client.dir}"
			promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()