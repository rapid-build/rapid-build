# build config
# ============
module.exports = ->
	# requires
	# ========
	require('./bootstrap')()
	path = require 'path'

	# vars
	# ====
	rootPath = path.dirname __dirname
	testPath = path.join rootPath, 'test'

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
		generated:    path.join rootPath, 'generated'
		node_modules: path.join rootPath, 'node_modules'
		tools:        path.join rootPath, 'tools'
		test:
			path:      testPath
			app:       path.join testPath, 'app'
			framework: path.join testPath, 'framework'
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
	config


