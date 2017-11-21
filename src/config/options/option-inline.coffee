module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init inline options
	# ===================
	inline = options.inline
	inline = {} unless isType.object inline

	inline.htmlExternalCss = {} unless isType.object inline.htmlExternalCss
	inline.htmlExternalCss.client = {} unless isType.object inline.htmlExternalCss.client
	inline.htmlExternalCss.client.enable = false unless isType.boolean inline.htmlExternalCss.client.enable

	inline.jsHtmlImports = {} unless isType.object inline.jsHtmlImports
	inline.jsHtmlImports.client = {} unless isType.object inline.jsHtmlImports.client
	inline.jsHtmlImports.client.enable = false unless isType.boolean inline.jsHtmlImports.client.enable

	# add inline options
	# ==================
	options.inline = inline

	# return
	# ======
	options


