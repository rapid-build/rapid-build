# API Options Prep
# ================
module.exports = (config, options) ->
	log    = require "#{config.req.helpers}/log"
	isType = require "#{config.req.helpers}/isType"

	# format options helpers
	# ======================
	buildOptions = ->
		options.build = {} unless isType.object options.build
		options.build.client = null unless isType.boolean options.build.client
		options.build.server = null unless isType.boolean options.build.server

	distAndSrcOptions = ->
		['dist', 'src'].forEach (v1) ->
			options[v1] = {} unless isType.object options[v1]
			options[v1].dir = null unless isType.string options[v1].dir
			['client', 'server'].forEach (v2) ->
				# dir
				options[v1][v2] = {} unless isType.object options[v1][v2]
				options[v1][v2].dir = null unless isType.string options[v1][v2].dir
				return if v2 is 'server'
				# types dir
				['bower', 'images', 'libs', 'scripts', 'styles', 'test', 'views'].forEach (v3) ->
					options[v1][v2][v3] = {} unless isType.object options[v1][v2][v3]
					options[v1][v2][v3].dir = null unless isType.string options[v1][v2][v3].dir

	portOptions = -> # server ports
		options.ports = {} unless isType.object options.ports
		options.ports.server   = null unless isType.number options.ports.server
		options.ports.reload   = null unless isType.number options.ports.reload
		options.ports.reloadUI = null unless isType.number options.ports.reloadUI
		options.ports.test     = null unless isType.number options.ports.test

	orderOptions = ->
		options.order = {} unless isType.object options.order
		options.order.scripts = {} unless isType.object options.order.scripts
		options.order.styles  = {} unless isType.object options.order.styles
		options.order.scripts.first = null unless isType.array options.order.scripts.first
		options.order.scripts.last  = null unless isType.array options.order.scripts.last
		options.order.styles.first  = null unless isType.array options.order.styles.first
		options.order.styles.last   = null unless isType.array options.order.styles.last

	angularOptions = ->
		options.angular = {} unless isType.object options.angular
		options.angular.modules       = null unless isType.array options.angular.modules
		options.angular.version       = null unless isType.string options.angular.version
		options.angular.moduleName    = null unless isType.string options.angular.moduleName
		options.angular.ngFormify     = null unless isType.boolean options.angular.ngFormify
		options.angular.httpBackend   = {}   unless isType.object options.angular.httpBackend
		options.angular.httpBackend.dev  = null unless isType.boolean options.angular.httpBackend.dev
		options.angular.httpBackend.prod = null unless isType.boolean options.angular.httpBackend.prod
		options.angular.httpBackend.dir  = null unless isType.string options.angular.httpBackend.dir
		options.angular.templateCache = {}   unless isType.object options.angular.templateCache
		options.angular.templateCache.dev              = null unless isType.boolean options.angular.templateCache.dev
		options.angular.templateCache.urlPrefix        = null unless isType.string options.angular.templateCache.urlPrefix
		options.angular.templateCache.useAbsolutePaths = null unless isType.boolean options.angular.templateCache.useAbsolutePaths

	spaOptions = ->
		options.spa = {} unless isType.object options.spa
		options.spa.title         = null unless isType.string options.spa.title
		options.spa.description   = null unless isType.string options.spa.description
		options.spa.src           = {}   unless isType.object options.spa.src
		options.spa.src.filePath  = null unless isType.string options.spa.src.filePath
		options.spa.dist          = {}   unless isType.object options.spa.dist
		options.spa.dist.fileName = null unless isType.string options.spa.dist.fileName
		options.spa.placeholders  = null unless isType.array  options.spa.placeholders

	minifyOptions = ->
		options.minify = {} unless isType.object options.minify
		options.minify.css       = {} unless isType.object options.minify.css
		options.minify.html      = {} unless isType.object options.minify.html
		options.minify.js        = {} unless isType.object options.minify.js
		options.minify.spa       = {} unless isType.object options.minify.spa
		options.minify.cacheBust = null unless isType.boolean options.minify.cacheBust
		options.minify.css.styles         = null unless isType.boolean options.minify.css.styles
		options.minify.css.splitMinFile   = null unless isType.boolean options.minify.css.splitMinFile
		options.minify.html.views         = null unless isType.boolean options.minify.html.views
		options.minify.html.templateCache = null unless isType.boolean options.minify.html.templateCache
		options.minify.js.scripts         = null unless isType.boolean options.minify.js.scripts
		options.minify.js.mangle          = null unless isType.boolean options.minify.js.mangle
		options.minify.spa.file           = null unless isType.boolean options.minify.spa.file

	excludeOptions = ->
		options.exclude = {} unless isType.object options.exclude
		options.exclude.angular = {} unless isType.object options.exclude.angular
		options.exclude.from    = {} unless isType.object options.exclude.from
		options.exclude.spa     = null unless isType.boolean options.exclude.spa
		options.exclude.angular.files   = null unless isType.boolean options.exclude.angular.files
		options.exclude.angular.modules = null unless isType.boolean options.exclude.angular.modules
		options.exclude.from.cacheBust  = null unless isType.array options.exclude.from.cacheBust
		options.exclude.from.minFile    = {} unless isType.object options.exclude.from.minFile
		options.exclude.from.spaFile    = {} unless isType.object options.exclude.from.spaFile
		options.exclude.from.dist       = {} unless isType.object options.exclude.from.dist
		options.exclude.from.minFile.scripts = null unless isType.array options.exclude.from.minFile.scripts
		options.exclude.from.minFile.styles  = null unless isType.array options.exclude.from.minFile.styles
		options.exclude.from.spaFile.scripts = null unless isType.array options.exclude.from.spaFile.scripts
		options.exclude.from.spaFile.styles  = null unless isType.array options.exclude.from.spaFile.styles
		options.exclude.from.dist.client     = null unless isType.array options.exclude.from.dist.client
		options.exclude.from.dist.server     = null unless isType.array options.exclude.from.dist.server

	testOptions = ->
		options.test = {} unless isType.object options.test
		options.test.browsers = null unless isType.array options.test.browsers

	serverDistOptions = -> # app server dist entry file
		options.dist.server.fileName = null unless isType.string options.dist.server.fileName

	serverOptions = ->
		options.server = {} unless isType.object options.server
		options.server.node_modules = null unless isType.array options.server.node_modules

	proxyOptions = ->
		options.httpProxy = null unless isType.array options.httpProxy

	extraCopy = ->
		options.extra.copy.client = null unless isType.array options.extra.copy.client
		options.extra.copy.server = null unless isType.array options.extra.copy.server

	extraCompile = ->
		options.extra.compile.client.coffee = null unless isType.array options.extra.compile.client.coffee
		options.extra.compile.client.es6    = null unless isType.array options.extra.compile.client.es6
		options.extra.compile.client.less   = null unless isType.array options.extra.compile.client.less
		options.extra.compile.client.sass   = null unless isType.array options.extra.compile.client.sass
		options.extra.compile.server.less   = null unless isType.array options.extra.compile.server.less
		options.extra.compile.server.sass   = null unless isType.array options.extra.compile.server.sass

	extraOptions = ->
		options.extra = {} unless isType.object options.extra
		options.extra.copy    = {} unless isType.object options.extra.copy
		options.extra.compile = {} unless isType.object options.extra.compile
		options.extra.compile.client = {} unless isType.object options.extra.compile.client
		options.extra.compile.server = {} unless isType.object options.extra.compile.server
		extraCopy()
		extraCompile()

	browserOptions = ->
		options.browser = {} unless isType.object options.browser
		options.browser.open = null unless isType.boolean options.browser.open

	# init
	# ====
	buildOptions()
	distAndSrcOptions() # must be 2nd
	portOptions()
	orderOptions()
	angularOptions()
	spaOptions()
	minifyOptions()
	excludeOptions()
	testOptions()
	serverDistOptions()
	serverOptions()
	proxyOptions()
	browserOptions()
	extraOptions()

	# logs
	# ====
	# log.json options, 'options ='

	# return
	# ======
	options

