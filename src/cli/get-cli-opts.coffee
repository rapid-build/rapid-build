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

	getCacheClean = (val) ->
		return false unless val
		return false if val is 'false'
		return true if val is true or val is 'true'
		return '*' if ['*','all'].indexOf(val) isnt -1
		false

	# configure
	# =========
	program
		.version config.build.pkg.version
		.option '-s, --skip-options [opts]', 'skip build option(s) ex: dev,prod', list, []
		.option '--cache-clean [value]', "cleans #{config.build.pkg.name}'s internal cache for an app, optionally provide * to clean internal cache for all apps"
		.option '--quick-start [location]', 'creates a simple application structure with a couple files. optional location: client or server. defaults to both'
		.parse process.argv

	# return
	# ======
	opts =
		cacheClean: getCacheClean program.cacheClean # bool | '*'
		quickStart: getQuickStart program.quickStart # []
		skipOpts:   program.skipOptions              # []
