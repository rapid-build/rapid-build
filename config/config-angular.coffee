module.exports = (config, options) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init angular
	# ============
	angular = {}

	# modules
	# =======
	angular.modules = options.angular.modules or []

	# version
	# =======
	angular.version = options.angular.version or null

	# dev
	# ===
	angular.dev = {}
	angular.dev.useTemplateCache = options.angular.dev.useTemplateCache or false

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


