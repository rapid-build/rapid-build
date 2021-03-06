module.exports = (config, options) ->
	path   = require 'path'
	log    = require "#{config.req.helpers}/log"
	isType = require "#{config.req.helpers}/isType"
	test   = require("#{config.req.helpers}/test")()

	# default modules
	# order matters because of 'ngMockE2E'
	# ====================================
	modules = ['ngMockE2E', 'ngResource', 'ngRoute', 'ngSanitize']
	modules.splice 1, modules.length - 1 if options.exclude.angular.modules

	# init angular
	# ============
	angular = {}

	# bootstrap
	# =========
	angular.bootstrap = {}
	angular.bootstrap.enabled = if options.angular.bootstrap is null then false else !!options.angular.bootstrap
	angular.bootstrap.elm     = if isType.string options.angular.bootstrap then options.angular.bootstrap else null

	# ng-formify
	# ==========
	angular.ngFormify = options.angular.ngFormify or false

	# httpBackend
	# ===========
	httpBackendDir = options.angular.httpBackend.dir or 'mocks'
	httpBackendDir = path.join config.src.app.client.scripts.dir, httpBackendDir
	angular.httpBackend = {}
	angular.httpBackend.dev     = options.angular.httpBackend.dev or false
	angular.httpBackend.prod    = options.angular.httpBackend.prod or false
	angular.httpBackend.enabled = false # see updateHttpBackendStatus()
	angular.httpBackend.dir     = httpBackendDir

	# modules
	# =======
	angular.modules = options.angular.modules or []
	angular.modules = modules.concat angular.modules

	# version
	# =======
	angular.version = options.angular.version or '1.x'

	# module name
	# ===========
	angular.moduleName = options.angular.moduleName or 'app'

	# template cache
	# ==============
	angular.templateCache = {}
	angular.templateCache.dev              = options.angular.templateCache.dev or false
	angular.templateCache.urlPrefix        = options.angular.templateCache.urlPrefix or ''
	angular.templateCache.useAbsolutePaths = options.angular.templateCache.useAbsolutePaths or false

	# rb bower dependencies
	# =====================
	angular.bowerDeps =
		'angular':          angular.version
		'angular-mocks':    angular.version
		'angular-resource': angular.version
		'angular-route':    angular.version
		'angular-sanitize': angular.version

	# methods
	# =======
	removeRbMocksModule = -> # helper
		angular.modules.splice 0, 1

	angular.removeRbMocksModule = ->
		if config.env.is.prod
			removeRbMocksModule() unless angular.httpBackend.prod
		else if not angular.httpBackend.dev
			removeRbMocksModule()

	angular.updateHttpBackendStatus = -> # called in update-angular-mocks-config
		isDefaultOrDev  = config.env.is.default or config.env.is.dev
		isProd          = config.env.is.prod
		isTest          = config.env.is.testClient
		httpBackendDev  = angular.httpBackend.dev
		httpBackendProd = angular.httpBackend.prod
		# the rules
		enabled = true if isDefaultOrDev and httpBackendDev
		enabled = true if isProd and httpBackendProd
		enabled = true if isTest and httpBackendDev and not isProd
		enabled = true if isTest and httpBackendProd and isProd

		config.angular.httpBackend.enabled = !!enabled

	# add angular to config
	# =====================
	config.angular = angular

	# logs
	# ====
	# log.json angular, 'angular ='

	# tests
	# =====
	test.log 'true', config.angular, 'add angular to config'

	# return
	# ======
	config


