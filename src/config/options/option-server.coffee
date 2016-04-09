module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init server options
	# ===================
	server = options.server
	server = {} unless isType.object server
	server.node_modules = null unless isType.array server.node_modules

	# add server options
	# ==================
	options.server = server

	# return
	# ======
	options


