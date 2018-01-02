module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init inline options
	# ===================
	inline = options.inline
	inline = {} unless isType.object inline

	inline.htmlAssets = {} unless isType.object inline.htmlAssets
	inline.htmlAssets.client = {} unless isType.object inline.htmlAssets.client
	inline.htmlAssets.client.enable = false unless isType.boolean inline.htmlAssets.client.enable

	inline.jsHtmlImports = {} unless isType.object inline.jsHtmlImports
	inline.jsHtmlImports.client = {} unless isType.object inline.jsHtmlImports.client
	inline.jsHtmlImports.client.enable = false unless isType.boolean inline.jsHtmlImports.client.enable

	# add inline options
	# ==================
	options.inline = inline

	# return
	# ======
	options


