# build core config
# =================
module.exports = ->
	# bootstrap
	# =========
	require('./bootstrap')()

	# build in order
	# ==============
	config = {}
	config = require("#{__dirname}/configs/config-paths") config
	config = require("#{__dirname}/configs/config-pkgs")  config

	# logging
	# =======
	# console.log 'CONFIG:\n'.info.bold, config

	# return
	# ======
	config


