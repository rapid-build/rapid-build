module.exports = (config, options) ->
	path   = require 'path'
	log    = require "#{config.req.helpers}/log"
	isType = require "#{config.req.helpers}/isType"
	test   = require("#{config.req.helpers}/test")()

	# init extra.copy
	# copy additional files to
	# dist that the build didn't copy
	# ===============================
	copy =
		rb:
			client: []
			server: []
		app:
			client: options.extra.copy.client or []
			server: options.extra.copy.server or []
		enabled:
			client: false
			server: false

	# format copy paths
	# =================
	formatCopyPaths = (appOrRb) ->
		for loc in ['client','server']
			files = copy[appOrRb][loc]
			continue unless files.length
			for file, i in files
				files[i] = path.join config.src[appOrRb][loc].dir, files[i]

	formatCopyPaths 'rb'
	formatCopyPaths 'app'

	# set enabled
	# ===========
	setEnabled = ->
		for appOrRb in ['rb','app']
			for loc in ['client','server']
				continue if copy.enabled[loc]
				glob = copy[appOrRb][loc]
				continue unless isType.array glob
				continue unless glob.length
				copy.enabled[loc] = true
	setEnabled()

	# add copy to config.extra
	# ========================
	config.extra.copy = copy

	# logs
	# ====
	# log.json copy, 'extra.copy ='

	# tests
	# =====
	test.log 'true', config.extra.copy, 'add extra.copy to config'

	# return
	# ======
	config