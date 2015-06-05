module.exports = (gulp, config) ->
	q             = require 'q'
	path          = require 'path'
	es            = require 'event-stream'
	gulpif        = require 'gulp-if'
	minifyHtml    = require 'gulp-minify-html'
	templateCache = require 'gulp-angular-templatecache'

	# globs
	# =====
	getGlob = (loc, type, lang) ->
		config.glob.src[loc].client[type][lang]
	glob =
		views:
			rb:  getGlob 'rb',  'views', 'html'
			app: getGlob 'app', 'views', 'html'

	# helpers
	# =======
	getAppOrRb = (base, loc, type) -> # base = file.base from buffer
		return if not base
		return 'rb' if base.indexOf(config[loc].rb.client[type].dir) isnt -1
		'app'

	# streams
	# =======
	addToDistPath = -> # add 'views/' for app and 'rapid-build/views/' for rb
		transform = (file, cb) ->
			appOrRb   = getAppOrRb file.base, 'src', 'views'
			dirName   = config.dist[appOrRb].client.views.dirName
			dirName   = path.join config.rb.prefix.distDir, dirName if appOrRb is 'rb'
			relPath   = path.join dirName, file.relative
			modPath   = path.join file.base, relPath
			file.path = modPath
			cb null, file
		es.map transform

	# tasks
	# =====
	runTask = (src, dest, file, isProd) ->
		defer = q.defer()
		opts  = {}
		opts.root   = '/' if config.angular.templateCache.useAbsolutePaths
		opts.module = 'app'
		gulp.src src
			.pipe addToDistPath()
			.pipe gulpif isProd, minifyHtml()
			.pipe templateCache file, opts
			.pipe gulp.dest dest
			.on 'end', ->
				console.log "created #{file}".yellow
				defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}template-cache", ->
		isProd = config.env.name is 'prod'
		file   = if isProd then 'min' else 'main'
		file   = config.fileName.views[file]
		dest   = config.dist.rb.client.scripts.dir
		src    = [ glob.views.rb, glob.views.app ]
		runTask src, dest, file, isProd



