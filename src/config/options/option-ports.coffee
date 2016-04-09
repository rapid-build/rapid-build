module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init server ports options
	# =========================
	ports = options.ports
	ports = {} unless isType.object ports
	ports.server   = null unless isType.number ports.server
	ports.reload   = null unless isType.number ports.reload
	ports.reloadUI = null unless isType.number ports.reloadUI
	ports.test     = null unless isType.number ports.test

	# add ports options
	# =================
	options.ports = ports

	# return
	# ======
	options


