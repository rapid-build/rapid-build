module.exports = (config, options) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# default modules
	# ===============
	modules = ['ngResource', 'ngRoute', 'ngSanitize']

	# init angular
	# ============
	angular = {}

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
	angular.templateCache.dev = {}
	angular.templateCache.dev.enable       = options.angular.templateCache.dev.enable or false
	angular.templateCache.useAbsolutePaths = options.angular.templateCache.useAbsolutePaths or false

	# rb bower dependencies
	# =====================
	angular.bowerDeps =
		'angular':          angular.version
		'angular-resource': angular.version
		'angular-route':    angular.version
		'angular-sanitize': angular.version

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


