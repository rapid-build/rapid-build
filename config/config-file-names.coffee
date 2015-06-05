module.exports = (config) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init fileName
	# =============
	fileName = {}
	fileName.scripts = {}
	fileName.styles  = {}
	fileName.views   = {}

	# names
	# =====
	fileName.scripts.all = 'all.js'
	fileName.styles.all  = 'all.css'
	fileName.views.main  = 'views.js'
	fileName.scripts.min = 'scripts.min.js'
	fileName.styles.min  = 'styles.min.js'
	fileName.views.min   = 'views.min.js'

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


