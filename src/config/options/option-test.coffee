module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init test options
	# =================
	test = options.test
	test = {} unless isType.object test
	test.client = {} unless isType.object test.client
	test.client.browsers = null unless isType.array test.client.browsers

	# add test options
	# ================
	options.test = test

	# return
	# ======
	options


