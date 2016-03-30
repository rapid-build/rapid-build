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
		['app', 'rb'].forEach (v) ->
			bower[v].file = defaults.file
			bower[v].dir  = if v is 'rb' then config.generated.pkg.path else config[v].dir
			bower[v].path = path.join bower[v].dir, bower[v].file
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


