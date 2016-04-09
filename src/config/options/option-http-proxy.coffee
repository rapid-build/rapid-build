module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init http proxy options
	# =======================
	httpProxy = options.httpProxy
	httpProxy = null unless isType.array httpProxy

	# add http proxy options
	# ======================
	options.httpProxy = httpProxy

	# return
	# ======
	options


