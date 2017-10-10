module.exports = (config, options) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init extra.watch
	# watch and copy additional static
	# files in src/[client|server]/
	# that the build doesn't watch
	# ================================
	watch =
		app:
			client: options.extra.watch.client or []
			server: options.extra.watch.server or []

	# format watch paths
	# ==================
	formatCopyPaths = (app) ->
		for loc in ['client','server']
			files = watch[app][loc]
			continue unless files.length
			for file, i in files
				files[i] = path.join config.src[app][loc].dir, files[i]

	formatCopyPaths 'app'

	# add watch to config.extra
	# =========================
	config.extra.watch = watch

	# logs
	# ====
	# log.json watch, 'extra.watch ='

	# tests
	# =====
	test.log 'true', config.extra.watch, 'add extra.watch to config'

	# return
	# ======
	config