# build config
# ============
module.exports = ->
	# requires
	# ========
	require('./bootstrap')()
	path = require 'path'

	# vars
	# ====
	rootPath      = path.dirname __dirname
	generatedPath = path.join rootPath, 'generated'
	testPath      = path.join rootPath, 'test'

	# int config
	# ==========
	config =
		pkgs:
			rb: {}
			test: {}
		paths:
			abs: {}
			rel: {}

	# paths abs
	# =========
	config.paths.abs =
		root:         rootPath
		node_modules: path.join rootPath, 'node_modules'
		temp:         path.join rootPath, 'temp'
		tools:        path.join rootPath, 'tools'
		generated:
			path:    generatedPath
			testApp: path.join generatedPath, 'build-test'
		test:
			path:      testPath
			app:       path.join testPath, 'app'
			bootstrap: path.join testPath, 'bootstrap'
			builds:    path.join testPath, 'builds'
			framework: path.join testPath, 'framework'
			helpers:   path.join testPath, 'helpers'
			init:      path.join testPath, 'init'
			tasks:     path.join testPath, 'tasks'
			tests:     path.join testPath, 'tests'

	# paths rel
	# =========
	setRelPaths = (paths, rels) -> # recursive
		for own k, v of paths
			if typeof v is 'string'
				rels[k] = v.replace(rootPath,'').substring 1
				continue
			rels[k] = {}
			setRelPaths v, rels[k]

	setRelPaths config.paths.abs, config.paths.rel

	# pkgs
	# ====
	config.pkgs.rb   = require path.join rootPath, 'package.json'
	config.pkgs.test = require path.join config.paths.abs.test.app, 'package.json'

	# return
	# ======
	# console.log "#{'CONFIG'.info.bold}:", config
	# console.log "#{'CONFIG PKGS'.info.bold}:", config.pkgs
	# console.log "#{'CONFIG PATHS'.info.bold}:", config.paths
	config


