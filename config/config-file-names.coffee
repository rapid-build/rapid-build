module.exports = (config) ->
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# helpers
	# =======
	getLoadFiles = (type) -> # for prod file loading order (order matters)
		first:  "first.#{type}"
		second: "second.#{type}"
		third:  "third.#{type}"
		middle: "middle.#{type}"
		last:   "last.#{type}"

	# defaults
	# ========
	loadScriptFiles = getLoadFiles 'js'
	loadStylesFiles = getLoadFiles 'css'

	# init fileName (used in config-temp.coffee)
	# ==========================================
	fileName =
		scripts:
			load: loadScriptFiles
			min: 'scripts.min.js'
		styles:
			load: loadStylesFiles
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


