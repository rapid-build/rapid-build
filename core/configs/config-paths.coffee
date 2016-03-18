module.exports = (config) ->
	# requires
	# ========
	path = require 'path'

	# vars
	# ====
	rootPath              = path.join __dirname, '..', '..'
	buildName             = require("#{rootPath}/package.json").name
	corePath              = path.join rootPath, 'core'
	generatedPath         = path.join rootPath, 'generated'
	testPath              = path.join rootPath, 'test'
	testPathApp           = path.join testPath, 'app'
	testPathAppDist       = path.join testPathApp, 'dist'
	testPathAppDistClient = path.join testPathAppDist, 'client'
	testPathAppDistServer = path.join testPathAppDist, 'server'
	testPathAppSrc        = path.join testPathApp, 'src'
	testPathAppSrcClient  = path.join testPathAppSrc, 'client'
	testPathAppSrcServer  = path.join testPathAppSrc, 'server'

	# int paths
	# =========
	paths = abs: {}, rel: {}

	# add abs
	# =======
	paths.abs =
		root:         rootPath
		node_modules: path.join rootPath, 'node_modules'
		temp:         path.join rootPath, 'temp'
		tools:        path.join rootPath, 'tools'
		core:
			path:  corePath
			tasks: path.join corePath, 'tasks'
		generated:
			path:    generatedPath
			testApp: path.join generatedPath, 'build-test'
		test:
			path:      testPath
			builds:    path.join testPath, 'builds'
			config:    path.join testPath, 'config'
			framework: path.join testPath, 'framework'
			helpers:   path.join testPath, 'helpers'
			init:      path.join testPath, 'init'
			tasks:     path.join testPath, 'tasks'
			tests:     path.join testPath, 'tests'
			app:
				path: testPathApp
				dist:
					path: testPathAppDist
					client:
						path:    testPathAppDistClient
						build:   path.join testPathAppDistClient, buildName
						bower:   path.join testPathAppDistClient, 'bower_components'
						images:  path.join testPathAppDistClient, 'images'
						libs:    path.join testPathAppDistClient, 'libs'
						scripts: path.join testPathAppDistClient, 'scripts'
						styles:  path.join testPathAppDistClient, 'styles'
						test:    path.join testPathAppDistClient, 'test'
						views:   path.join testPathAppDistClient, 'views'
					server:
						path:  testPathAppDistServer
						build: path.join testPathAppDistServer, buildName
						test:  path.join testPathAppDistServer, 'test'
				src:
					path: testPathAppSrc
					client:
						path:    testPathAppSrcClient
						bower:   path.join testPathAppSrcClient, 'bower_components'
						images:  path.join testPathAppSrcClient, 'images'
						libs:    path.join testPathAppSrcClient, 'libs'
						scripts: path.join testPathAppSrcClient, 'scripts'
						styles:  path.join testPathAppSrcClient, 'styles'
						test:    path.join testPathAppSrcClient, 'test'
						views:   path.join testPathAppSrcClient, 'views'
					server:
						path: testPathAppSrcServer
						test: path.join testPathAppSrcServer, 'test'

	# add rel
	# =======
	setRelPaths = (_paths, rels) -> # recursive
		for own k, v of _paths
			if typeof v is 'string'
				rels[k] = v.replace(rootPath,'').substring 1
				continue
			rels[k] = {}
			setRelPaths v, rels[k]

	setRelPaths paths.abs, paths.rel

	# logging
	# =======
	# console.log 'PATHS:\n'.info.bold, paths
	# console.log 'PATHS ABS:\n'.info.bold, paths.abs
	# console.log 'PATHS REL:\n'.info.bold, paths.rel
	# console.log 'PATHS ABS TEST:\n'.info.bold, paths.abs.test
	# console.log 'PATHS REL TEST:\n'.info.bold, paths.rel.test
	# console.log 'PATHS ABS TEST APP:\n'.info.bold, paths.abs.test.app
	# console.log 'PATHS REL TEST APP:\n'.info.bold, paths.rel.test.app

	# add and return
	# ==============
	config.paths = paths
	config


