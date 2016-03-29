module.exports = (config, options) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init httpProxy
	# ==============
	httpProxy = options.httpProxy or [] # format: { context: [] or '', options: {} }

	# add httpProxy to config
	# =======================
	config.httpProxy = httpProxy

	# logs
	# ====
	# log.json httpProxy, 'httpProxy ='

	# tests
	# =====
	test.log 'true', config.httpProxy, 'add httpProxy to config'

	# return
	# ======
	config


