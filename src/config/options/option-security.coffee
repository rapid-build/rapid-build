module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init security options
	# =====================
	security = options.security
	security = {} unless isType.object security
	security.client = {} unless isType.object security.client
	security.client.clickjacking = null unless isType.boolean security.client.clickjacking

	# add security options
	# ====================
	options.security = security

	# return
	# ======
	options


