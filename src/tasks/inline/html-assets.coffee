module.exports = (config, gulp, taskOpts={}) ->
	promiseHelp      = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.inline.htmlAssets.client.enable
	q                = require 'q'
	log              = require "#{config.req.helpers}/log"
	inlineHtmlAssets = require "#{config.req.plugins}/gulp-inline-html-assets"
	forWatchFile     = !!taskOpts.watchFile

	runTask = (src, dest, base) ->
		defer   = q.defer()
		srcOpts = { base, allowEmpty: true }
		gulp.src src, srcOpts
			.on 'error', (e) -> log.error e, 'inline html assets'
			.pipe inlineHtmlAssets()
			.on 'error', (e) -> log.error e, 'inline html assets'
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
			src  = taskOpts.watchFile.path
			dest = taskOpts.watchFile.rbDistDir
			base = dest
			runTask src, dest, base

		runMulti: (env) ->
			return promiseHelp.get() if config.env.is.prod and env is 'dev' # skip, will run later in minify-client
			src  = config.glob.dist.app.client.views.all.concat config.spa.dist.path
			dest = config.dist.app.client.root.dir
			base = dest
			promise = runTask src, dest, base
			promise.done ->
				log.task "inlined html assets in: #{config.dist.app.client.dir}"
			promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti taskOpts.env