module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init minify options
	# ===================
	minify = options.minify
	minify = {} unless isType.object minify
	minify.css       = {} unless isType.object minify.css
	minify.html      = {} unless isType.object minify.html
	minify.spa       = {} unless isType.object minify.spa
	minify.cacheBust = null unless isType.boolean minify.cacheBust
	minify.css.styles         = null unless isType.boolean minify.css.styles
	minify.css.fileName       = null unless isType.string minify.css.fileName
	minify.css.splitMinFile   = null unless isType.boolean minify.css.splitMinFile
	minify.html.views         = null unless isType.boolean minify.html.views
	minify.html.templateCache = null unless isType.boolean minify.html.templateCache
	minify.html.options       = {}   unless isType.object minify.html.options
	minify.spa.file           = null unless isType.boolean minify.spa.file

	minify.client = {} unless isType.object minify.client
	minify.server = {} unless isType.object minify.server
	minify.client.js = {} unless isType.object minify.client.js
	minify.server.js = {} unless isType.object minify.server.js

	minify.client.js.es6      = null unless isType.boolean minify.client.js.es6
	minify.client.js.enable   = null unless isType.boolean minify.client.js.enable
	minify.client.js.options  = null unless isType.object minify.client.js.options
	minify.client.js.fileName = null unless isType.string minify.client.js.fileName

	minify.server.js.es6      = null unless isType.boolean minify.server.js.es6
	minify.server.js.enable   = null unless isType.boolean minify.server.js.enable
	minify.server.js.options  = null unless isType.object minify.server.js.options

	minify.server.json = {} unless isType.object minify.server.json
	minify.server.json.enable = null unless isType.boolean minify.server.json.enable

	# add minify options
	# ==================
	options.minify = minify

	# return
	# ======
	options


