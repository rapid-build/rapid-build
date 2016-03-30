module.exports = (config, options) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init build
	# ==========
	build = {}
	build.client = if options.build.client is false then false else true
	build.server = if options.build.server is false then false else true

	# build check
	# ===========
	unless build.client or build.server
		process.on 'exit', ->
			msg = 'Atleast one build, client or server must be enabled.'
			console.error msg.error
		.exit 1

	# add build to config
	# ===================
	config.build = build

	# logs
	# ====
	# log.json build, 'build ='

	# tests
	# =====
	test.log 'true', config.build, 'add build to config'

	# return
	# ======
	config


