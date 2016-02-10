module.exports = (config, options) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()
	pkg  = require "#{config.req.app}/package.json"

	# init app
	# ========
	app = {}
	app.name    = pkg.name
	app.version = pkg.version
	app.dir     = config.req.app
	app.name    = path.basename app.dir unless app.name # incase no package.json

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


