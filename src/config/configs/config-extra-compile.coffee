module.exports = (config, options) ->
	path   = require 'path'
	log    = require "#{config.req.helpers}/log"
	isType = require "#{config.req.helpers}/isType"
	test   = require("#{config.req.helpers}/test")()

	# init extra.compile
	# compile additional files [coffee|es6|htmlScripts|less|sass]
	# to dist that the build didn't compile
	# ===========================================================
	compile =
		rb:
			client:
				coffee:      []
				es6:         []
				htmlScripts: []
				less:        []
				sass:        []
			server:
				less: []
				sass: []
		app:
			client:
				coffee:      options.extra.compile.client.coffee      or []
				es6:         options.extra.compile.client.es6         or []
				htmlScripts: options.extra.compile.client.htmlScripts or []
				less:        options.extra.compile.client.less        or []
				sass:        options.extra.compile.client.sass        or []
			server:
				less: options.extra.compile.server.less or []
				sass: options.extra.compile.server.sass or []
		enabled:
			client:
				coffee:      false
				es6:         false
				htmlScripts: false
				less:        false
				sass:        false
			server:
				less: false
				sass: false

	# format compile paths
	# ====================
	formatCompilePaths = (appOrRb) ->
		for loc in ['client','server']
			for lang in ['coffee','es6','htmlScripts','less','sass']
				files = compile[appOrRb][loc][lang]
				continue unless files
				continue unless files.length
				for file, i in files
					files[i] = path.join config.src[appOrRb][loc].dir, files[i]

	formatCompilePaths 'rb'
	formatCompilePaths 'app'

	# set enabled
	# ===========
	setEnabled = ->
		for appOrRb in ['rb','app']
			for loc in ['client','server']
				for lang in ['coffee','es6','htmlScripts','less','sass']
					continue if compile.enabled[loc][lang]
					glob = compile[appOrRb][loc][lang]
					continue unless isType.array glob
					continue unless glob.length
					compile.enabled[loc][lang] = true
	setEnabled()

	# add compile to config.extra
	# ===========================
	config.extra.compile = compile

	# logs
	# ====
	# log.json compile, 'extra.compile ='

	# tests
	# =====
	test.log 'true', config.extra.compile, 'add extra.compile to config'

	# return
	# ======
	config