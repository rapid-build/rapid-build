module.exports = (app, config) ->
	proxyMidware = require 'http-proxy-middleware' # express middleware
	proxies      = []

	for proxy in config.httpProxy
		continue unless proxy.context
		proxies.push proxyMidware proxy.context, proxy.options

	return unless proxies.length

	# add middleware to express app
	# =============================
	app.use proxies

	# return middleware
	# =================
	proxyMidware