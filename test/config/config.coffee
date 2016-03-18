# TEST CONFIG
# ===========
module.exports = (pkgRoot) ->
	# helpers
	# =======
	getOpts = ->
		opts = process.argv.slice 2
		opts = (opt.toLowerCase() for opt in opts) # prep work

	# build config (in order)
	# =======================
	config  = require("#{pkgRoot}/core/config")() # also bootstraps colors pkg
	CONFIGS = "#{config.paths.abs.test.config}/configs"
	opts    = getOpts opts
	config  = require("#{CONFIGS}/config-build") config, opts
	config  = require("#{CONFIGS}/config-test")  config, opts

	# logging
	# =======
	# console.log 'CONFIG:\n'.info, config

	# return
	# ======
	config


