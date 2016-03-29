# BUILD EXTRA CONFIG
# npm test depends on this!
# =========================
module.exports = ->
	# build in order
	# ==============
	config = {}
	config = require("#{__dirname}/configs/config-paths") config
	config = require("#{__dirname}/configs/config-pkgs")  config

	# logging
	# =======
	# console.log 'CONFIG:\n', config

	# return
	# ======
	config


