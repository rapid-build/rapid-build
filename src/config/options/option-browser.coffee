module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init browser options
	# ====================
	browser = options.browser
	browser = {} unless isType.object browser
	browser.open   = null unless isType.boolean browser.open
	browser.reload = null unless isType.boolean browser.reload

	# add browser options
	# ===================
	options.browser = browser

	# return
	# ======
	options


