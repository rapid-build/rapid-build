module.exports = (config) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init server
	# ===========
	server = {}

	# messages
	# ========
	server.msg =
		start: "Server started on #{config.ports.server}"
		noScripts: 'No application server scripts to load.'

	# add server to config
	# ====================
	config.server = server

	# logs
	# ====
	# log.json server, 'server ='

	# tests
	# =====
	test.log 'true', config.server, 'add server to config'

	# return
	# ======
	config


