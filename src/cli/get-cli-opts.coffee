module.exports = (config) ->
	# requires
	# ========
	program = require 'commander'

	# helpers
	# =======
	list = (val) ->
		val.split ','

	getQuickStart = (val) ->
		return [] unless val
		defaults = ['client', 'server']
		return defaults if val is true
		val = val.toLowerCase()
		return [] if defaults.indexOf(val) is -1
		[val]

	# configure
	# =========
	program
		.version config.build.pkg.version
		.option '-s, --skip-options [opts]', 'skip build option(s) ex: dev,prod', list, []
		.option '--quick-start [location]', 'creates a simple application structure with a couple files. optional location: client or server. defaults to both'
		.parse process.argv

	# return
	# ======
	opts =
		skipOpts:   program.skipOptions # []
		quickStart: getQuickStart program.quickStart  # []
