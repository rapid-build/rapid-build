module.exports = (config, options) ->
	path = require 'path'
	log  = require "#{config.req.helpers}/log"
	test = require("#{config.req.helpers}/test")()
	pkg  = require "#{config.req.app}/package.json"

	# helpers
	# =======
	getSrcDir = (_custom, dir) ->
		rbDir  = config.src.rb.client.dir
		appDir = config.src.app.client.dir
		return rbDir if not _custom
		return appDir if not dir
		# to keep windows happy
		dir = dir.split path.sep
		for own k, v of dir
			continue if not v
			appDir = path.join appDir, v
		appDir

	# defaults
	# ========
	custom   = !!options.spa.src.file
	srcFile  = options.spa.src.file or 'spa.html'
	distFile = options.spa.dist.file or srcFile
	srcDir   = getSrcDir custom, options.spa.src.dir

	# init spa
	# ========
	spa = {}
	spa.custom      = custom
	spa.title       = options.spa.title or pkg.name or 'Application'
	spa.description = options.spa.description or pkg.description or null

	# dist
	# ====
	spa.dist =
		file: distFile
		path: path.join config.dist.app.client.dir, distFile

	# src
	# ===
	spa.src =
		file: srcFile
		path: path.join srcDir, srcFile

	# placeholders
	# ============
	spa.placeholders = options.spa.placeholders or []

	# exclude
	# =======
	spa.exclude =
		rb:
			scripts: []
			styles:  []
		app:
			scripts: options.spa.exclude.scripts or []
			styles:  options.spa.exclude.styles  or []

	formatExcludes = ->
		for own k1, v1 of spa.exclude
			for own k2, v2 of v1
				continue if not v2.length
				v2.forEach (v3, i) ->
					v2[i] = path.join config.dist[k1].client.dir, v3
					v2[i] = "!#{v2[i]}"

	formatExcludes()

	# add spa to config
	# =================
	config.spa = spa

	# logs
	# ====
	# log.json spa, 'spa ='

	# tests
	# =====
	test.log 'true', config.spa, 'add spa to config'

	# return
	# ======
	config


