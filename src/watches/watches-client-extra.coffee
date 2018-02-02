module.exports = (config) -> # :Object[]
	return [] if not config.build.client or not config.extra.watch.app.client.length

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
		extra: config.extra.watch.app.client

	# Add Watches
	# ===========
	Watch.add 'copy-extra-files:client', Globs.extra, lang: 'extra', srcType: 'root', loc: 'client', logTaskName: 'extra client', bsReload: 'change'

	# Return
	# ======
	Watches