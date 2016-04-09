module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init extra options
	# ==================
	extra = options.extra
	extra = {} unless isType.object extra
	extra.copy    = {} unless isType.object extra.copy
	extra.compile = {} unless isType.object extra.compile
	extra.compile.client = {} unless isType.object extra.compile.client
	extra.compile.server = {} unless isType.object extra.compile.server

	# extra copy options
	# ==================
	extra.copy.client = null unless isType.array extra.copy.client
	extra.copy.server = null unless isType.array extra.copy.server

	# extra compile options
	# =====================
	extra.compile.client.coffee = null unless isType.array extra.compile.client.coffee
	extra.compile.client.es6    = null unless isType.array extra.compile.client.es6
	extra.compile.client.less   = null unless isType.array extra.compile.client.less
	extra.compile.client.sass   = null unless isType.array extra.compile.client.sass
	extra.compile.server.less   = null unless isType.array extra.compile.server.less
	extra.compile.server.sass   = null unless isType.array extra.compile.server.sass

	# add extra options
	# =================
	options.extra = extra

	# return
	# ======
	options


