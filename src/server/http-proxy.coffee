module.exports = (app, config, opts) ->
	return if not config.httpProxy.length
	proxyMidware = require 'http-proxy-middleware' # express middleware
	proxies      = []

	for proxy in config.httpProxy
		continue if not proxy.context
		proxies.push proxyMidware proxy.context, proxy.options

	return if not proxies.length

	# add middleware to express app
	# =============================
	app.use proxies