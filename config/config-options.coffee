# API - Prep Options
# dist.dir                                          = (string)  defaults to 'dist'
# dist.client.dir                                   = (string)  defaults to 'client'
# dist.client[images|libs|scripts|styles|views].dir = (string)  defaults to property name
# dist.client.spa.file                              = (string)  defaults to 'spa.html'
# dist.server.dir                                   = (string)  defaults to 'server'
# dist.server.file                                  = (string)  defaults to 'routes.js'
# src.dir                                           = (string)  defaults to 'src'
# src.client.dir                                    = (string)  defaults to 'client'
# src.client[images|libs|scripts|styles|views].dir  = (string)  defaults to property name
# src.server.dir                                    = (string)  defaults to 'server'
# ports.server                                      = (int)     defaults to 3000
# ports.reload                                      = (int)     defaults to 3001
# order[scripts|styles][first|last]                 = (array)   expects file paths
# angular.modules                                   = (array)   additional angular modules
# angular.version                                   = (string)  defaults to '1.4.x'
# angular.moduleName                                = (string)  application module name
# angular.templateCache.dev.enable                  = (boolean) defaults to false
# angular.templateCache.useAbsolutePaths            = (boolean) defaults to false
# ========================================================================================
module.exports = (config, options) ->
	log    = require "#{config.req.helpers}/log"
	isType = require "#{config.req.helpers}/isType"

	# options
	# =======
	formatOptions = ->
		['dist', 'src'].forEach (v1) ->
			options[v1] = {} if not isType.object options[v1]
			options[v1].dir = null if not isType.string options[v1].dir
			['client', 'server'].forEach (v2) ->
				# dir
				options[v1][v2] = {} if not isType.object options[v1][v2]
				options[v1][v2].dir = null if not isType.string options[v1][v2].dir
				return if v2 is 'server'
				# types dir
				['images', 'libs', 'scripts', 'styles', 'views'].forEach (v3) ->
					options[v1][v2][v3] = {} if not isType.object options[v1][v2][v3]
					options[v1][v2][v3].dir = null if not isType.string options[v1][v2][v3].dir
				# spa dist file
				if v1 is 'dist'
					options[v1][v2].spa = {} if not isType.object options[v1][v2].spa
					options[v1][v2].spa.file = null if not isType.string options[v1][v2].spa.file

	formatServerOptions	= -> # app server dist entry file
		options.dist.server.file = null if not isType.string options.dist.server.file

	formatPortOptions = -> # server ports
		options.ports = {} if not isType.object options.ports
		options.ports.server = null if not isType.number options.ports.server
		options.ports.reload = null if not isType.number options.ports.reload

	formatOrderOptions = ->
		options.order = {} if not isType.object options.order
		options.order.scripts = {} if not isType.object options.order.scripts
		options.order.styles  = {} if not isType.object options.order.styles
		options.order.scripts.first = null if not isType.array options.order.scripts.first
		options.order.scripts.last  = null if not isType.array options.order.scripts.last
		options.order.styles.first  = null if not isType.array options.order.styles.first
		options.order.styles.last   = null if not isType.array options.order.styles.last

	formatAngularOptions = ->
		options.angular = {} if not isType.object options.angular
		options.angular.modules       = null if not isType.array options.angular.modules
		options.angular.version       = null if not isType.string options.angular.version
		options.angular.moduleName    = null if not isType.string options.angular.moduleName
		options.angular.templateCache = {}   if not isType.object options.angular.templateCache
		options.angular.templateCache.useAbsolutePaths = null if not isType.boolean options.angular.templateCache.useAbsolutePaths
		options.angular.templateCache.dev = {} if not isType.object options.angular.templateCache.dev
		options.angular.templateCache.dev.enable = null if not isType.boolean options.angular.templateCache.dev.enable

	formatOptions()
	formatServerOptions()
	formatPortOptions()
	formatAngularOptions()
	formatOrderOptions()

	# logs
	# ====
	# log.json options, 'options ='

	# return
	# ======
	options

