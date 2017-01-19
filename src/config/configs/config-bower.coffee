module.exports = (config, options) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# defaults
	# ========
	defaults =
		file: 'bower.json'

	# init json
	# =========
	bower = {}
	bower.rb  = {}
	bower.app = {}

	# add info
	# ========
	addInfo = ->
		['app','rb'].forEach (appOrRb) ->
			bower[appOrRb].file = defaults.file
			bower[appOrRb].dir  = config.src[appOrRb].client.dir
			bower[appOrRb].path = path.join bower[appOrRb].dir, bower[appOrRb].file

	addInfo()

	# add bower to config
	# ===================
	config.bower = bower

	# logs
	# ====
	# log.json bower, 'bower ='

	# tests
	# =====
	test.log 'true', config.bower, 'add bower to config'

	# return
	# ======
	config


