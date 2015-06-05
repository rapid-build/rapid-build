module.exports = (config) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init fileName (used in config-temp.coffee)
	# ==========================================
	fileName =
		scripts:
			all: 'all.js'
			min: 'scripts.min.js'
		styles:
			all: 'all.css'
			min: 'styles.min.css'
		views:
			main: 'views.js'
			min:  'views.min.js'

	# add fileName to config
	# ======================
	config.fileName = fileName

	# logs
	# ====
	# log.json fileName, 'fileName ='

	# tests
	# =====
	test.log 'true', config.fileName, 'add fileName to config'

	# return
	# ======
	config


