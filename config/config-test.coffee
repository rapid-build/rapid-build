module.exports = (config, options) ->
	log   = require "#{config.req.helpers}/log"
	_test = require("#{config.req.helpers}/test")()

	# init test
	# =========
	test =
		client: {}
		dist:   {}

	# browsers
	# ========
	getBrowsers = ->
		browsers     = ['PhantomJS'] # default
		browserOpts  = ['Chrome', 'Firefox', 'IE', 'Safari'] # case sensitive
		userBrowsers = options.test.client.browsers
		return browsers unless userBrowsers
		return browsers unless userBrowsers.length
		# format the browser names, they are case sensitive
		userBrowsers = userBrowsers.map (string) ->
			string.trim().toLowerCase()
		for userBrowser in userBrowsers
			match = null
			for browser in browserOpts
				if browser.toLowerCase() is userBrowser
					match = browser; break
			continue unless match
			browsers.push match
		browsers

	test.client.browsers = getBrowsers()

	# test files
	# ==========
	getTestFiles = (loc) ->
		structure = {}
		for appOrRb in ['rb', 'app']
			structure[appOrRb] =
				client:
					scripts: config.glob[loc][appOrRb].client.test.js
					styles:  config.glob[loc][appOrRb].client.test.css
				server:
					scripts: config.glob[loc][appOrRb].server.test.js
		structure

	test.dist = getTestFiles 'dist'

	# add test to config
	# ==================
	config.test = test

	# logs
	# ====
	# log.json test, 'test ='

	# tests
	# =====
	_test.log 'true', config.test, 'add test to config'

	# return
	# ======
	config


