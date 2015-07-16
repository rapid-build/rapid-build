module.exports = (config, options) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init app
	# ========
	app = {}
	app.dir = config.req.app

	# add app to config
	# =================
	config.app = app

	# logs
	# ====
	# log.json app, 'app ='

	# tests
	# =====
	test.log 'true', config.app, 'add app to config'

	# return
	# ======
	config


