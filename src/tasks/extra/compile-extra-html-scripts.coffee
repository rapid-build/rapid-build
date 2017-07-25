module.exports = (config, gulp, taskOpts={}) ->
	q                  = require 'q'
	plumber            = require 'gulp-plumber'
	log                = require "#{config.req.helpers}/log"
	extraHelp          = require("#{config.req.helpers}/extra") config
	compileHtmlScripts = require "#{config.req.plugins}/gulp-compile-html-scripts"

	runTask = (src, dest, base, appOrRb, loc) ->
		defer = q.defer()
		gulp.src src, { base }
			.pipe plumber()
			.pipe compileHtmlScripts()
			.pipe gulp.dest dest
			.on 'end', ->
				log.task "compiled extra html es6 scripts to: #{config.dist.app[loc].dir}"
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: (loc) ->
			extraHelp.run.tasks.async runTask, 'compile', 'htmlScripts', [loc]

	# return
	# ======
	api.runTask taskOpts.loc