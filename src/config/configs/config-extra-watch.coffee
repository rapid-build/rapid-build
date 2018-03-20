module.exports = (config, options) ->
	path     = require 'path'
	log      = require "#{config.req.helpers}/log"
	isType   = require "#{config.req.helpers}/isType"
	pathHelp = require "#{config.req.helpers}/path"
	test     = require("#{config.req.helpers}/test")()

	# init extra.watch
	# watch and copy additional static
	# files in src/[client|server]/
	# that the build doesn't watch
	# ================================
	watch =
		app:
			client: options.extra.watch.client or []
			server: options.extra.watch.server or []
		enabled:
			client: false
			server: false

	# format watch paths
	# ==================
	formatCopyPaths = (app) ->
		for loc in ['client','server']
			files = watch[app][loc]
			continue unless files.length
			for file, i in files
				files[i] = path.join config.src[app][loc].dir, files[i]
				files[i] = pathHelp.format files[i]

	formatCopyPaths 'app'

	# set enabled
	# ===========
	setEnabled = ->
		for appOrRb in ['app']
			for loc in ['client','server']
				continue if watch.enabled[loc]
				glob = watch[appOrRb][loc]
				continue unless isType.array glob
				continue unless glob.length
				watch.enabled[loc] = true
	setEnabled()

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