module.exports = (config, options) ->
	log    = require "#{config.req.helpers}/log"
	isType = require "#{config.req.helpers}/isType"
	test   = require("#{config.req.helpers}/test")()

	# init inline
	# ============
	inline =
		jsHtmlImports:
			client:
				enable: options.inline.jsHtmlImports.client.enable
		htmlAssets:
			dev:    options.inline.htmlAssets.dev
			enable: options.inline.htmlAssets.enable
			options:
				attribute:  options.inline.htmlAssets.options.attribute
				svgAsImage: options.inline.htmlAssets.options.svgAsImage
				ignore:     options.inline.htmlAssets.options.ignore

	# add inline to config
	# =====================
	config.inline = inline

	# logs
	# ====
	# log.json inline, 'inline ='

	# tests
	# =====
	test.log 'true', config.inline, 'add inline to config'

	# return
	# ======
	config


