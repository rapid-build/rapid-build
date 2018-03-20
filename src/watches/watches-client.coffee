module.exports = (config) -> # :Object[]
	return [] unless config.build.client

	# Requires
	# ========
	log         = require "#{config.req.helpers}/log"
	pathHelp    = require "#{config.req.helpers}/path"
	promiseHelp = require "#{config.req.helpers}/promise"

	# Watches
	# =======
	Watches = [] # :Object[]

	# Watch Helpers
	# =============
	Watch =
		add: (task, glob, opts={}) -> # :void
			Watches.push { task, glob, opts }

		# conditionals :boolean
		# =====================
		html: ->
			not config.angular.templateCache.dev

		htmlAssets: ->
			config.inline.htmlAssets.dev and
			config.inline.htmlAssets.enable

		jsHtmlImports: ->
			config.inline.jsHtmlImports.client.enable

		spa: ->
			config.spa.custom and
			not config.exclude.spa

		templateCache: ->
			config.angular.templateCache.dev and
			not config.exclude.default.client.files

	# Globs
	# =====
	Globs =
		htmlAssets: [].concat(
			config.glob.dist.app.client.scripts.all
			config.glob.dist.app.client.styles.all
			config.glob.dist.app.client.views.all
			pathHelp.format config.spa.dist.path
		)
		jsHtmlImports: [].concat(
			config.glob.dist.app.client.scripts.all
			config.glob.dist.app.client.views.all
		)
		spa: [
			pathHelp.format config.spa.src.path
		]
		src: config.glob.src.app.client

	# Callbacks
	# =========
	Callbacks =
		cleanStyles: (file) -> # :Promise
			config.internal.deleteFileImports file.rbAppOrRb, file.rbDistPath
			promiseHelp.get()

	# Add Watches
	# ===========
	Watch.add 'less',                       Globs.src.styles.less,    lang: 'less',           srcType: 'styles',  cleanCb: Callbacks.cleanStyles, extDist: 'css'
	Watch.add 'sass',                       Globs.src.styles.sass,    lang: 'sass',           srcType: 'styles',  cleanCb: Callbacks.cleanStyles, extDist: 'css'
	Watch.add 'copy-css',                   Globs.src.styles.css,     lang: 'css',            srcType: 'styles',  cleanCb: Callbacks.cleanStyles, logTaskName: 'css'
	Watch.add 'es6:client',                 Globs.src.scripts.es6,    lang: 'es6',            srcType: 'scripts', extDist: 'js'
	Watch.add 'copy-images',                Globs.src.images.all,     lang: 'image',          srcType: 'images',  bsReload: true, logTaskName: 'image'
	Watch.add 'coffee:client',              Globs.src.scripts.coffee, lang: 'coffee',         srcType: 'scripts', extDist: 'js'
	Watch.add 'copy-js:client',             Globs.src.scripts.js,     lang: 'js',             srcType: 'scripts', logTaskName: 'js'
	Watch.add 'copy-html',                  Globs.src.views.html,     lang: 'html',           srcType: 'views',   bsReload: true, logTaskName: 'html' if Watch.html()
	Watch.add 'template-cache',             Globs.src.views.html,     lang: 'html',           srcType: 'views',   logTaskName: 'template cache', taskOnly: true if Watch.templateCache()
	Watch.add 'inline-html-assets:dev',     Globs.htmlAssets,         lang: 'html asset',     srcType: 'views',   logTaskName: 'html asset',     addLog: true, silent: true if Watch.htmlAssets()
	Watch.add 'inline-js-html-imports:dev', Globs.jsHtmlImports,      lang: 'js html import', srcType: 'scripts', logTaskName: 'js html import', addLog: true, silent: true, keepWatchOpts: true if Watch.jsHtmlImports()
	Watch.add 'watch-build-spa',            Globs.spa,                lang: config.spa.src.file, logTaskName: config.spa.src.file if Watch.spa()

	# Return
	# ======
	Watches