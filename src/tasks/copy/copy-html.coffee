module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q                  = require 'q'
	gulpif             = require 'gulp-if'
	plumber            = require 'gulp-plumber'
	log                = require "#{config.req.helpers}/log"
	ngFormify          = require "#{config.req.plugins}/gulp-ng-formify"
	compileHtmlScripts = require "#{config.req.plugins}/gulp-compile-html-scripts"
	taskRunner         = require("#{config.req.helpers}/task-runner") config
	runNgFormify       = config.angular.ngFormify

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.on 'error', (e) -> defer.reject e
			.pipe plumber()
			.pipe gulpif runNgFormify, ngFormify()
			.pipe gulpif config.compile.htmlScripts.client.enable, compileHtmlScripts()
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "completed task: #{Task.name}"
		defer.promise

	# API
	# ===
	api =
		runSingle: ->
			runTask Task.opts.watchFile.path, Task.opts.watchFile.rbDistDir

		runMulti: ->
			promise = taskRunner.async runTask, 'views', 'html', ['client'], Task
			promise.then ->
				msgs = ["copied views to: #{config.dist.app.client.dir}"]
				if config.compile.htmlScripts.client.enable
					msgs.unshift "compiled html es6 scripts to: #{config.dist.app.client.dir}"
				log: true
				message: msgs

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()