module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFilePath

	# requires
	# ========
	q               = require 'q'
	path            = require 'path'
	log             = require "#{config.req.helpers}/log"
	pathHelp        = require "#{config.req.helpers}/path"
	promiseHelp     = require "#{config.req.helpers}/promise"
	urlRegX         = /url\s*\(\s*['"]?(.*?)['"]?\s*\)(?![^\*]*?\*\/)/g
	importNoUrlRegX = /@import\s*?['"]+?(.*?)['"]+?(?![^\*]*?\*\/)/g

	# constants
	# =========
	CLIENT_DIST_ROOT = path.join config.app.dir, config.dist.app.client.dir

	# helpers
	# =======
	getRelativePath = (cssPath, absPath) ->
		relPath = path.relative cssPath, absPath
		# for windows
		relPath = path.normalize relPath
		relPath = pathHelp.swapBackslashes relPath

	findAndReplace = (css, cssPath, regX) ->
		css.replace regX, (match, urlPath) ->
			isAbsolute = urlPath[0] is '/'
			return match unless isAbsolute
			absPath = path.join CLIENT_DIST_ROOT, urlPath
			relPath = getRelativePath cssPath, absPath
			relUrl  = match.replace urlPath, relPath
			# log.task relUrl, 'minor'
			return relUrl

	# tasks
	# =====
	runTask = (appOrRb, type, opts={}) ->
		defer = q.defer()
		src   = opts.single if opts.single
		base  = if opts.single then config.dist.app.client.styles.dir else null
		src   = config.glob.dist[appOrRb].client[type][opts.glob] if opts.glob
		dest  = config.dist[appOrRb].client[type].dir
		gulp.src src, { base }
			.on 'error', (e) -> defer.reject e
			.on 'data', (file) ->
				css = file.contents
				return unless css
				css     = css.toString()
				cssPath = path.dirname file.path # css file directory path
				css     = findAndReplace css, cssPath, urlRegX         # match = url('/images/x.png')
				css     = findAndReplace css, cssPath, importNoUrlRegX # match = @import '/imports/x.css'
				file.contents = new Buffer css
			.pipe gulp.dest dest
			.on 'end', ->
				defer.resolve message: "completed task: #{Task.name}"
		defer.promise

	# API
	# ===
	api =
		runSingle: -> # for watch
			runTask 'app', 'styles', single: Task.opts.watchFilePath

		runMulti: -> # async
			q.all([
				runTask 'rb',  'bower',  glob: 'css'
				runTask 'rb',  'libs',   glob: 'css'
				runTask 'rb',  'styles', glob: 'all'
				runTask 'app', 'bower',  glob: 'css'
				runTask 'app', 'libs',   glob: 'css'
				runTask 'app', 'styles', glob: 'all'
			]).then ->
				log: true
				message: 'changed all css urls to relative'

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()


