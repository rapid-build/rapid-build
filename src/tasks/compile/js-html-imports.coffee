module.exports = (config, gulp, taskOpts={}) ->
	promiseHelp          = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.compile.jsHtmlImports.client.enable
	q                    = require 'q'
	log                  = require "#{config.req.helpers}/log"
	compileJsHtmlImports = require "#{config.req.plugins}/gulp-compile-js-html-imports"
	forWatchFile         = !!taskOpts.watchFile

	runTask = (src, dest, base) ->
		defer   = q.defer()
		srcOpts = { base }
		gulp.src src, srcOpts
			.pipe compileJsHtmlImports()
			.on 'data', ->
				taskOpts.watchFile.rbLog() if forWatchFile
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runSingle: ->
			src  = taskOpts.watchFile.rbDistPath
			dest = config.dist.app.client.root.dir
			base = taskOpts.watchFile.rbDistDir
			# console.log 'SRC:', src
			# console.log 'DEST:', dest
			# console.log 'BASE:', base
			runTask taskOpts.watchFile.path, taskOpts.watchFile.rbDistDir, base

		runMulti: (loc) ->
			src  = config.glob.dist.app[loc].scripts.all
			dest = config.dist.app[loc].root.dir
			base = dest
			# console.log 'SRC:', src
			# console.log 'DEST:', dest
			# console.log 'BASE:', base
			promise = runTask src, dest, base
			promise.done ->
				log.task "compiled js html imports in: #{config.dist.app[loc].dir}"
			promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti taskOpts.loc