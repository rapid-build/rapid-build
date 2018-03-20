module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.inline.jsHtmlImports.client.enable
	return promiseHelp.get() if config.env.is.prod and Task.opts.env is 'dev'  # skip, will run later in minify-client
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q   = require 'q'
	log = require "#{config.req.helpers}/log"
	inlineJsHtmlImports = require "#{config.req.plugins}/gulp-inline-js-html-imports"

	runTask = (src, dest, base) ->
		defer   = q.defer()
		srcOpts = { base, allowEmpty: true }
		gulp.src src, srcOpts
			.on 'error', (e) -> defer.reject e
			.pipe inlineJsHtmlImports()
			.on 'error', (e) -> defer.reject e
			.on 'data', ->
				try
					Task.opts.watchFile.rbLog() if forWatchFile
				catch e
					console.warn "#{Task.name}\n#{e.message}".warn
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "completed task: #{Task.name}"
		defer.promise

	# API
	# ===
	api =
		runSingle: ->
			src  = Task.opts.watchFile.path
			dest = Task.opts.watchFile.rbDistDir
			base = dest
			runTask src, dest, base

		runMulti: ->
			src  = config.glob.dist.app.client.scripts.all
			dest = config.dist.app.client.root.dir
			base = dest
			promise = runTask src, dest, base
			promise.then ->
				log: true
				message: "inlined js html imports in: #{config.dist.app.client.dir}"

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()