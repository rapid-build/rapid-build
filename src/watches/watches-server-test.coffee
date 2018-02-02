module.exports = (config) -> # :Object[]
	return [] if not config.build.server or not config.env.is.testServer

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
		test: config.glob.src.app.server.test

	# Add Watches
	# ===========
	Watch.add 'copy-server-tests', Globs.test.js,     lang: 'js',     srcType: 'test', loc:'server', isTest: true, logTaskName: 'server test'
	Watch.add 'copy-server-tests', Globs.test.es6,    lang: 'es6',    srcType: 'test', loc:'server', isTest: true, logTaskName: 'server test', loc:'server', extDist: 'js'
	Watch.add 'copy-server-tests', Globs.test.coffee, lang: 'coffee', srcType: 'test', loc:'server', isTest: true, logTaskName: 'server test', loc:'server', extDist: 'js'

	# Return
	# ======
	Watches