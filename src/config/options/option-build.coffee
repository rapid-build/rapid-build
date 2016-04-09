module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init build options
	# ==================
	build = options.build
	build = {} unless isType.object build
	build.client = null unless isType.boolean build.client
	build.server = null unless isType.boolean build.server

	# add build options
	# =================
	options.build = build

	# return
	# ======
	options


