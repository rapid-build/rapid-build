module.exports = (config) -> # :Object[]
	return [] if not config.build.server or not config.extra.watch.app.server.length

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
		extra: config.extra.watch.app.server

	# Add Watches
	# ===========
	Watch.add 'copy-extra-files:server', Globs.extra, lang: 'extra', srcType: 'root', loc: 'server', logTaskName: 'extra server', bsReload: 'change'

	# Return
	# ======
	Watches