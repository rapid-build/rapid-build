# TEST CONFIG
# ===========
module.exports = (pkgRoot) ->
	# helpers
	# =======
	getOpts = -> # prep work
		opts = process.argv.slice 2
		return opts unless opts.length
		for opt, i in opts
			continue if opt.indexOf('options:') isnt -1
			opts[i] = opt.toLowerCase()
		opts

	# build config (in order)
	# =======================
	config  = require("#{pkgRoot}/extra/tasks/get-config")()
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


