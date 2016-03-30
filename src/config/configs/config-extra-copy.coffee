module.exports = (config, options) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

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

	# add copy to config.extra
	# ========================
	config.extra.copy = copy

	# logs
	# ====
	# log.json extra.copy, 'extra.copy ='

	# tests
	# =====
	test.log 'true', config.extra.copy, 'add extra.copy to config'

	# return
	# ======
	config