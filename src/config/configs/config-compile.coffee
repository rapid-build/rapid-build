module.exports = (config, options) ->
	log    = require "#{config.req.helpers}/log"
	isType = require "#{config.req.helpers}/isType"
	test   = require("#{config.req.helpers}/test")()

	# init compile
	# ============
	compile =
		htmlScripts:
			client:
				enable: options.compile.htmlScripts.client.enable

		typescript:
			client:
				enable:  options.compile.typescript.client.enable
				entries: options.compile.typescript.client.entries
			server:
				enable: options.compile.typescript.server.enable

	compile.typescript.client.entries = ['main.ts'] if isType.null compile.typescript.client.entries

	# add compile to config
	# =====================
	config.compile = compile

	# logs
	# ====
	# log.json compile, 'compile ='

	# tests
	# =====
	test.log 'true', config.compile, 'add compile to config'

	# return
	# ======
	config


