module.exports = (config, options) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()
	pkg  = require "#{config.req.app}/package.json"

	# init spa
	# ========
	spa = {}
	spa.title       = options.spa.title or pkg.name or 'Application'
	spa.description = options.spa.description or pkg.description or null

	# add spa to config
	# =====================
	config.spa = spa

	# logs
	# ====
	# log.json spa, 'spa ='

	# tests
	# =====
	test.log 'true', config.spa, 'add spa to config'

	# return
	# ======
	config


