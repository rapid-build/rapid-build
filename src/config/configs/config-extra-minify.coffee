module.exports = (config, options) ->
	path   = require 'path'
	log    = require "#{config.req.helpers}/log"
	isType = require "#{config.req.helpers}/isType"
	test   = require("#{config.req.helpers}/test")()

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
		enabled:
			client:
				css: false
				js:  false

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

	# set enabled
	# ===========
	setEnabled = ->
		for appOrRb in ['rb','app']
			for loc in ['client']
				for lang in ['css','js']
					continue if minify.enabled[loc][lang]
					glob = minify[appOrRb][loc][lang]
					continue unless isType.array glob
					continue unless glob.length
					minify.enabled[loc][lang] = true
	setEnabled()

	# add minify to config.extra
	# ==========================
	config.extra.minify = minify

	# logs
	# ====
	# log.json minify, 'extra.minify ='

	# tests
	# =====
	test.log 'true', config.extra.minify, 'add extra.minify to config'

	# return
	# ======
	config