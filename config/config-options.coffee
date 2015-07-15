# API - Prep Options
# dist.dir                                          = (string)  defaults to 'dist'
# dist.client.dir                                   = (string)  defaults to 'client'
# dist.client[images|scripts|styles|test|views].dir = (string)  defaults to property name
# dist.client.bower.dir                             = (string)  defaults to 'bower_components'
# dist.client.libs.dir                              = (string)  defaults to 'libs' = 3rd party libraries that aren't bower components
# dist.server.dir                                   = (string)  defaults to 'server'
# dist.server.file                                  = (string)  defaults to 'routes.js'
# src.dir                                           = (string)  defaults to 'src'
# src.client.dir                                    = (string)  defaults to 'client'
# src.client[images|scripts|styles|test|views].dir  = (string)  defaults to property name
# src.client.bower.dir                              = (string)  defaults to 'bower_components'
# src.client.libs.dir                               = (string)  defaults to 'libs' = 3rd party libraries that aren't bower components
# src.server.dir                                    = (string)  defaults to 'server'
# ports.server                                      = (int)     defaults to 3000
# ports.reload                                      = (int)     defaults to 3001
# order[scripts|styles][first|last]                 = (array)   expects file paths
# angular.modules                                   = (array)   additional angular modules
# angular.version                                   = (string)  defaults to '1.x'
# angular.moduleName                                = (string)  application module name
# angular.httpBackend.dev                           = (boolean) defaults to false
# angular.httpBackend.prod                          = (boolean) defaults to false
# angular.httpBackend.dir                           = (string)  defaults to 'mocks'
# angular.templateCache.dev                         = (boolean) defaults to false
# angular.templateCache.useAbsolutePaths            = (boolean) defaults to false
# spa.title                                         = (string)  defaults to package.json name
# spa.description                                   = (string)  defaults to package.json description
# spa.src.file                                      = (string)  defaults to 'spa.html'
# spa.src.dir                                       = (string)  defaults to null
# spa.dist.file                                     = (string)  defaults to spa.src.file or 'spa.html'
# spa.placeholders                                  = (array of strings) = optionals: ['scripts', 'styles', 'description', 'moduleName', 'title'] or ['all']
# minify.css.styles                                 = (boolean) defaults to true
# minify.css.splitMinFile                           = (boolean) defaults to true
# minify.html.views                                 = (boolean) defaults to true
# minify.html.templateCache                         = (boolean) defaults to true
# minify.js.scripts                                 = (boolean) defaults to true
# minify.js.mangle                                  = (boolean) defaults to true
# minify.spa.file                                   = (boolean) defaults to true
# minify.cacheBust                                  = (boolean) defaults to true
# exclude.angular.files                             = (boolean) defaults to false
# exclude.from.cacheBust                            = (array of strings) = file paths: exclude files from the cache bust
# exclude.from.minFile[scripts|styles]              = (array of strings) = file paths: exclude script or style files from automatically being generated in the scripts.min.js or styles.min.css file
# exclude.from.spaFile[scripts|styles]              = (array of strings) = file paths: exclude script or style files from automatically being generated in the spa.html file
# =============================================================================================================================================================================================
module.exports = (config, options) ->
	log    = require "#{config.req.helpers}/log"
	isType = require "#{config.req.helpers}/isType"

	# format options helpers
	# ======================
	distAndSrcOptions = ->
		['dist', 'src'].forEach (v1) ->
			options[v1] = {} if not isType.object options[v1]
			options[v1].dir = null if not isType.string options[v1].dir
			['client', 'server'].forEach (v2) ->
				# dir
				options[v1][v2] = {} if not isType.object options[v1][v2]
				options[v1][v2].dir = null if not isType.string options[v1][v2].dir
				return if v2 is 'server'
				# types dir
				['bower', 'images', 'libs', 'scripts', 'styles', 'test', 'views'].forEach (v3) ->
					options[v1][v2][v3] = {} if not isType.object options[v1][v2][v3]
					options[v1][v2][v3].dir = null if not isType.string options[v1][v2][v3].dir

	serverOptions = -> # app server dist entry file
		options.dist.server.file = null if not isType.string options.dist.server.file

	portOptions = -> # server ports
		options.ports = {} if not isType.object options.ports
		options.ports.server = null if not isType.number options.ports.server
		options.ports.reload = null if not isType.number options.ports.reload

	orderOptions = ->
		options.order = {} if not isType.object options.order
		options.order.scripts = {} if not isType.object options.order.scripts
		options.order.styles  = {} if not isType.object options.order.styles
		options.order.scripts.first = null if not isType.array options.order.scripts.first
		options.order.scripts.last  = null if not isType.array options.order.scripts.last
		options.order.styles.first  = null if not isType.array options.order.styles.first
		options.order.styles.last   = null if not isType.array options.order.styles.last

	angularOptions = ->
		options.angular = {} if not isType.object options.angular
		options.angular.modules       = null if not isType.array options.angular.modules
		options.angular.version       = null if not isType.string options.angular.version
		options.angular.moduleName    = null if not isType.string options.angular.moduleName
		options.angular.httpBackend   = {}   if not isType.object options.angular.httpBackend
		options.angular.httpBackend.dev  = null if not isType.boolean options.angular.httpBackend.dev
		options.angular.httpBackend.prod = null if not isType.boolean options.angular.httpBackend.prod
		options.angular.httpBackend.dir  = null if not isType.string options.angular.httpBackend.dir
		options.angular.templateCache = {}   if not isType.object options.angular.templateCache
		options.angular.templateCache.dev              = null if not isType.boolean options.angular.templateCache.dev
		options.angular.templateCache.useAbsolutePaths = null if not isType.boolean options.angular.templateCache.useAbsolutePaths

	spaOptions = ->
		options.spa = {} if not isType.object options.spa
		options.spa.title        = null if not isType.string options.spa.title
		options.spa.description  = null if not isType.string options.spa.description
		options.spa.src          = {}   if not isType.object options.spa.src
		options.spa.src.dir      = null if not isType.string options.spa.src.dir
		options.spa.src.file     = null if not isType.string options.spa.src.file
		options.spa.dist         = {}   if not isType.object options.spa.dist
		options.spa.dist.file    = null if not isType.string options.spa.dist.file
		options.spa.placeholders = null if not isType.array  options.spa.placeholders

	minifyOptions = ->
		options.minify = {} if not isType.object options.minify
		options.minify.css       = {} if not isType.object options.minify.css
		options.minify.html      = {} if not isType.object options.minify.html
		options.minify.js        = {} if not isType.object options.minify.js
		options.minify.spa       = {} if not isType.object options.minify.spa
		options.minify.cacheBust = null if not isType.boolean options.minify.cacheBust
		options.minify.css.styles         = null if not isType.boolean options.minify.css.styles
		options.minify.css.splitMinFile   = null if not isType.boolean options.minify.css.splitMinFile
		options.minify.html.views         = null if not isType.boolean options.minify.html.views
		options.minify.html.templateCache = null if not isType.boolean options.minify.html.templateCache
		options.minify.js.scripts         = null if not isType.boolean options.minify.js.scripts
		options.minify.js.mangle          = null if not isType.boolean options.minify.js.mangle
		options.minify.spa.file           = null if not isType.boolean options.minify.spa.file

	excludeOptions = ->
		options.exclude = {} if not isType.object options.exclude
		options.exclude.angular = {} if not isType.object options.exclude.angular
		options.exclude.from    = {} if not isType.object options.exclude.from
		options.exclude.angular.files  = null if not isType.boolean options.exclude.angular.files
		options.exclude.from.cacheBust = null if not isType.array options.exclude.from.cacheBust
		options.exclude.from.minFile   = {} if not isType.object options.exclude.from.minFile
		options.exclude.from.spaFile   = {} if not isType.object options.exclude.from.spaFile
		options.exclude.from.minFile.scripts = null if not isType.array options.exclude.from.minFile.scripts
		options.exclude.from.minFile.styles  = null if not isType.array options.exclude.from.minFile.styles
		options.exclude.from.spaFile.scripts = null if not isType.array options.exclude.from.spaFile.scripts
		options.exclude.from.spaFile.styles  = null if not isType.array options.exclude.from.spaFile.styles

	# init
	# ====
	distAndSrcOptions() # must be first
	serverOptions()
	portOptions()
	orderOptions()
	angularOptions()
	spaOptions()
	minifyOptions()
	excludeOptions()

	# logs
	# ====
	# log.json options, 'options ='

	# return
	# ======
	options

