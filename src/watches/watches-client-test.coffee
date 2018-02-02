module.exports = (config) -> # :Object[]
	return [] if not config.build.client or not config.env.is.testClient

	# Requires
	# ========
	log = require "#{config.req.helpers}/log"

	# Watches
	# =======
	Watches = [] # :Object[]

	# Watch Helpers
	# =============
	Watch =
		add: (task, glob, opts={}) -> # :void
			Watches.push { task, glob, opts }

	# Globs
	# =====
	Globs =
		test: config.glob.src.app.client.test

	# Add Watches
	# ===========
	Watch.add 'copy-client-tests', Globs.test.js,     lang: 'js',     srcType: 'test', isTest: true, logTaskName: 'client test'
	Watch.add 'copy-client-tests', Globs.test.es6,    lang: 'es6',    srcType: 'test', isTest: true, logTaskName: 'client test', extDist: 'js'
	Watch.add 'copy-client-tests', Globs.test.coffee, lang: 'coffee', srcType: 'test', isTest: true, logTaskName: 'client test', extDist: 'js'

	# Return
	# ======
	Watches