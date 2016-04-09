module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init order options
	# ==================
	order = options.order
	order = {} unless isType.object order
	order.scripts = {} unless isType.object order.scripts
	order.styles  = {} unless isType.object order.styles
	order.scripts.first = null unless isType.array order.scripts.first
	order.scripts.last  = null unless isType.array order.scripts.last
	order.styles.first  = null unless isType.array order.styles.first
	order.styles.last   = null unless isType.array order.styles.last

	# add order options
	# =================
	options.order = order

	# return
	# ======
	options


