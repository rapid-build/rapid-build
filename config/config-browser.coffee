module.exports = (config, options) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init browser
	# ============
	browser = {}
	browser.open   = if options.browser.open   is false then false else true
	browser.reload = if options.browser.reload is false then false else true

	# add browser to config
	# =====================
	config.browser = browser

	# logs
	# ====
	# log.json browser, 'browser ='

	# tests
	# =====
	test.log 'true', config.browser, 'add browser to config'

	# return
	# ======
	config


