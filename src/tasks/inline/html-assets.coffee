module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.inline.htmlAssets.enable
	return promiseHelp.get() if config.env.is.prod and Task.opts.env is 'dev' # skip, will run later in minify-client
	return promiseHelp.get() if config.env.is.dev and !config.inline.htmlAssets.dev
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	q   = require 'q'
	log = require "#{config.req.helpers}/log"
	inlineHtmlAssets = require "#{config.req.plugins}/gulp-inline-html-assets"

	runTask = (src, dest, base) ->
		defer   = q.defer()
		srcOpts = { base, allowEmpty: true }
		gulp.src src, srcOpts
			.on 'error', (e) -> defer.reject e
			.pipe inlineHtmlAssets config.inline.htmlAssets.options
			.on 'error', (e) -> defer.reject e
			.on 'data', ->
				Task.opts.watchFile.rbLog() if forWatchFile
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
			src  = config.glob.dist.app.client.views.all.concat config.spa.dist.path
			dest = config.dist.app.client.root.dir
			base = dest
			promise = runTask src, dest, base
			promise.then ->
				log: true
				message: "inlined html assets in: #{config.dist.app.client.dir}"

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()