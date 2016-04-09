module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init exclude options
	# ====================
	exclude = options.exclude
	exclude = {} unless isType.object exclude
	exclude.angular = {} unless isType.object exclude.angular
	exclude.default = {} unless isType.object exclude.default
	exclude.from    = {} unless isType.object exclude.from
	exclude.spa     = null unless isType.boolean exclude.spa
	exclude.angular.files   = null unless isType.boolean exclude.angular.files
	exclude.angular.modules = null unless isType.boolean exclude.angular.modules
	exclude.default.client  = {} unless isType.object exclude.default.client
	exclude.default.server  = {} unless isType.object exclude.default.server
	exclude.from.cacheBust  = null unless isType.array exclude.from.cacheBust
	exclude.from.minFile    = {} unless isType.object exclude.from.minFile
	exclude.from.spaFile    = {} unless isType.object exclude.from.spaFile
	exclude.from.dist       = {} unless isType.object exclude.from.dist
	exclude.from.minFile.scripts = null unless isType.array exclude.from.minFile.scripts
	exclude.from.minFile.styles  = null unless isType.array exclude.from.minFile.styles
	exclude.from.spaFile.scripts = null unless isType.array exclude.from.spaFile.scripts
	exclude.from.spaFile.styles  = null unless isType.array exclude.from.spaFile.styles
	exclude.from.dist.client     = null unless isType.array exclude.from.dist.client
	exclude.from.dist.server     = null unless isType.array exclude.from.dist.server
	exclude.default.client.files = null unless isType.boolean exclude.default.client.files
	exclude.default.server.files = null unless isType.boolean exclude.default.server.files

	# add exclude options
	# ===================
	options.exclude = exclude

	# return
	# ======
	options


