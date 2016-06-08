module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init angular options
	# ====================
	angular = options.angular
	angular = {} unless isType.object angular
	angular.modules       = null unless isType.array angular.modules
	angular.version       = null unless isType.string angular.version
	angular.moduleName    = null unless isType.string angular.moduleName
	angular.bootstrap     = null if not isType.boolean(angular.bootstrap) and not isType.string angular.bootstrap
	angular.ngFormify     = null unless isType.boolean angular.ngFormify
	angular.httpBackend   = {}   unless isType.object angular.httpBackend
	angular.httpBackend.dev  = null unless isType.boolean angular.httpBackend.dev
	angular.httpBackend.prod = null unless isType.boolean angular.httpBackend.prod
	angular.httpBackend.dir  = null unless isType.string angular.httpBackend.dir
	angular.templateCache = {}   unless isType.object angular.templateCache
	angular.templateCache.dev              = null unless isType.boolean angular.templateCache.dev
	angular.templateCache.urlPrefix        = null unless isType.string angular.templateCache.urlPrefix
	angular.templateCache.useAbsolutePaths = null unless isType.boolean angular.templateCache.useAbsolutePaths

	# add angular options
	# ===================
	options.angular = angular

	# return
	# ======
	options


