module.exports = (config) -> # :Object[]
	return [] unless config.build.server

	# Requires
	# ========
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

	# Watches
	# =======
	Watches = [] # :Object[]

	# Watch Helpers
	# =============
	Watch =
		add: (task, glob, opts={}) -> # :void
			Watches.push { task, glob, opts }

		# conditionals :boolean
		# =====================
		typescript: ->
			config.compile.typescript.server.enable

	# Globs
	# =====
	Globs =
		src: config.glob.src.app.server.scripts
		typescript: [].concat(
			config.glob.src.app.server.scripts.ts
			"!#{config.glob.src.app.server.typings.defs}"
		)

	# Add Watches
	# ===========
	Watch.add 'copy-js:server',    Globs.src.js,     lang: 'js',         srcType: 'scripts', loc: 'server', bsReload: true
	Watch.add 'es6:server',        Globs.src.es6,    lang: 'es6',        srcType: 'scripts', loc: 'server', bsReload: true, extDist: 'js'
	Watch.add 'coffee:server',     Globs.src.coffee, lang: 'coffee',     srcType: 'scripts', loc: 'server', bsReload: true, extDist: 'js'
	Watch.add 'typescript:server', Globs.typescript, lang: 'typescript', srcType: 'scripts', loc: 'server', bsReload: true, extDist: 'js', logTaskName: 'typescript' if Watch.typescript()

	# Return
	# ======
	Watches