module.exports = (config, options) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init extra object
	# contains useful tasks that
	# the build doesn't do by default
	# ===============================
	extra = {}

	# add extra to config
	# ===================
	config.extra = extra

	# tests
	# =====
	test.log 'true', config.extra, 'add extra to config'

	# return
	# ======
	config