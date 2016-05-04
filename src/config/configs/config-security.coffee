module.exports = (config, options) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init security
	# =============
	security = {}
	security.client = {}
	security.client.clickjacking = if options.security.client.clickjacking is false then false else true

	# add security to config
	# ======================
	config.security = security

	# logs
	# ====
	# log.json security, 'security ='

	# tests
	# =====
	test.log 'true', config.security, 'add security to config'

	# return
	# ======
	config


