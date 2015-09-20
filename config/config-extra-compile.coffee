module.exports = (config, options) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init extra.compile
	# compile additional files [coffee|es6|less]
	# to dist that the build didn't compile
	# ==========================================
	compile =
		rb:
			client:
				coffee: []
				es6:    []
				less:   []
			server:
				less:   []
		app:
			client:
				coffee: options.extra.compile.client.coffee or []
				es6:    options.extra.compile.client.es6    or []
				less:   options.extra.compile.client.less   or []
			server:
				less:   options.extra.compile.server.less   or []

	# format compile paths
	# ====================
	formatCompilePaths = (appOrRb) ->
		for loc in ['client','server']
			for lang in ['coffee','es6','less']
				files = compile[appOrRb][loc][lang]
				continue unless files
				continue unless files.length
				for file, i in files
					files[i] = path.join config.src[appOrRb][loc].dir, files[i]

	formatCompilePaths 'rb'
	formatCompilePaths 'app'

	# add compile to config.extra
	# ===========================
	config.extra.compile = compile

	# logs
	# ====
	# log.json extra.compile, 'extra.compile ='

	# tests
	# =====
	test.log 'true', config.extra.compile, 'add extra.compile to config'

	# return
	# ======
	config