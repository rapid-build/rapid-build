module.exports = (config, options) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()
	pkg  = require "#{config.req.app}/package.json"

	# init spaFile
	# ============
	spaFile = {}
	spaFile.title       = options.spaFile.title or pkg.name or 'Application'
	spaFile.description = options.spaFile.description or pkg.description or null

	# add spaFile to config
	# =====================
	config.spaFile = spaFile

	# logs
	# ====
	# log.json spaFile, 'spaFile ='

	# tests
	# =====
	test.log 'true', config.spaFile, 'add spaFile to config'

	# return
	# ======
	config


