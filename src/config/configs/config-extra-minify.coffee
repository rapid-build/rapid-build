module.exports = (config, options) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()

	# init extra.minify
	# minify additional client files [css|js]
	# in dist that the build didn't minify
	# =======================================
	minify =
		rb:
			client:
				css: []
				js:  []
		app:
			client:
				css: options.extra.minify.client.css or []
				js:  options.extra.minify.client.js  or []

	# format minify paths
	# ===================
	formatMinifyPaths = (appOrRb) ->
		for loc in ['client']
			for lang in ['css','js']
				files = minify[appOrRb][loc][lang]
				continue unless files
				continue unless files.length
				for file, i in files
					files[i] = path.join config.dist[appOrRb][loc].dir, files[i]

	formatMinifyPaths 'rb'
	formatMinifyPaths 'app'

	# add minify to config.extra
	# ==========================
	config.extra.minify = minify

	# logs
	# ====
	# log.json extra.minify, 'extra.minify ='

	# tests
	# =====
	test.log 'true', config.extra.minify, 'add extra.minify to config'

	# return
	# ======
	config