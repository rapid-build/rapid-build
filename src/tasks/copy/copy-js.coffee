module.exports = (config, gulp, taskOpts={}) ->
	q                  = require 'q'
	gulpif             = require 'gulp-if'
	log                = require "#{config.req.helpers}/log"
	tasks              = require("#{config.req.helpers}/tasks") config
	compileHtmlImports = require "#{config.req.plugins}/gulp-compile-html-imports"
	forWatchFile       = !!taskOpts.watchFile
	CHI_ENABLED        = config.compile.htmlImports.client.enable

	runTask = (src, dest, opts={}) ->
		defer = q.defer()
		chi   = CHI_ENABLED and opts.appOrRb is 'app' and opts.loc is 'client'
		gulp.src src
			.pipe gulpif chi, compileHtmlImports()
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runSingle: ->
			opts =
				appOrRb: taskOpts.watchFile.rbAppOrRb
				loc: taskOpts.watchFile.rbClientOrServer
			runTask taskOpts.watchFile.path, taskOpts.watchFile.rbDistDir, opts

		runMulti: (loc) ->
			promise = tasks.run.async runTask, 'scripts', 'js', [loc]
			promise.done ->
				log.task "copied js to: #{config.dist.app[loc].dir}"
			promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti taskOpts.loc