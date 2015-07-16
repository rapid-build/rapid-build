module.exports = (config, options) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init ports
	# ==========
	ports = {}
	ports.server = options.ports.server or 3000
	ports.reload = options.ports.reload or 3001
	ports.test   = options.ports.test   or 9876

	# add ports to config
	# ===================
	config.ports = ports

	# logs
	# ====
	# log.json ports, 'ports ='

	# tests
	# =====
	test.log 'true', config.ports, 'add ports to config'

	# return
	# ======
	config


