module.exports = (config) ->
	# requires
	# ========
	program = require 'commander'

	# helpers
	# =======
	list = (val) ->
		val.split ','

	# configure
	# =========
	program
		.version config.build.pkg.version
		.option '-s, --skip-options [opts]', 'skip build option(s) ex: dev,prod', list, []
		.parse process.argv

	# return
	# ======
	opts =
		skipOpts: program.skipOptions # []
