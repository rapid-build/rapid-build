module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init inline options
	# ===================
	inline = options.inline
	inline = {} unless isType.object inline

	# html assets
	# ==========
	inline.htmlAssets = {} unless isType.object inline.htmlAssets
	inline.htmlAssets.dev     = true unless isType.boolean inline.htmlAssets.dev
	inline.htmlAssets.enable  = false unless isType.boolean inline.htmlAssets.enable
	inline.htmlAssets.options = {} unless isType.object inline.htmlAssets.options
	inline.htmlAssets.options.attribute  = false unless isType.string inline.htmlAssets.options.attribute
	inline.htmlAssets.options.svgAsImage = false unless isType.boolean inline.htmlAssets.options.svgAsImage
	inline.htmlAssets.options.ignore     = [] unless isType.stringArray inline.htmlAssets.options.ignore

	# js html imports
	# ===============
	inline.jsHtmlImports = {} unless isType.object inline.jsHtmlImports
	inline.jsHtmlImports.client = {} unless isType.object inline.jsHtmlImports.client
	inline.jsHtmlImports.client.enable = false unless isType.boolean inline.jsHtmlImports.client.enable

	# add inline options
	# ==================
	options.inline = inline

	# return
	# ======
	options


