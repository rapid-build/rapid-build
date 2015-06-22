module.exports = (config, options) ->
	log    = require "#{config.req.helpers}/log"
	test   = require("#{config.req.helpers}/test")()
	isType = require "#{config.req.helpers}/isType"

	# helpers
	# =======
	getOption = (opt) ->
		opt = options.minify[opt]
		return true if isType.null opt
		opt

	# init minify
	# ===========
	minify =
		css:  getOption 'css'
		html: getOption 'html'
		js:   getOption 'js'

	# add minify to config
	# ====================
	config.minify = minify

	# logs
	# ====
	# log.json minify, 'minify ='

	# tests
	# =====
	test.log 'true', config.minify, 'add minify to config'

	# return
	# ======
	config


