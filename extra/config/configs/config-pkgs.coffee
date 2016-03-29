module.exports = (config) ->
	# int pkgs
	# ========
	pkgs = rb: {}, test: {}

	# populate
	# ========
	pkgs.rb   = require "#{config.paths.abs.root}/package.json"
	pkgs.test = require "#{config.paths.abs.test.app.path}/package.json"

	# logging
	# =======
	# console.log 'PKGS:', pkgs

	# add and return
	# ==============
	config.pkgs = pkgs
	config


