module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init minify options
	# ===================
	minify = options.minify
	minify = {} unless isType.object minify
	minify.css       = {} unless isType.object minify.css
	minify.html      = {} unless isType.object minify.html
	minify.js        = {} unless isType.object minify.js
	minify.spa       = {} unless isType.object minify.spa
	minify.cacheBust = null unless isType.boolean minify.cacheBust
	minify.css.styles         = null unless isType.boolean minify.css.styles
	minify.css.fileName       = null unless isType.string minify.css.fileName
	minify.css.splitMinFile   = null unless isType.boolean minify.css.splitMinFile
	minify.html.views         = null unless isType.boolean minify.html.views
	minify.html.templateCache = null unless isType.boolean minify.html.templateCache
	minify.js.scripts         = null unless isType.boolean minify.js.scripts
	minify.js.fileName        = null unless isType.string minify.js.fileName
	minify.js.mangle          = null unless isType.boolean minify.js.mangle
	minify.spa.file           = null unless isType.boolean minify.spa.file

	# add minify options
	# ==================
	options.minify = minify

	# return
	# ======
	options


