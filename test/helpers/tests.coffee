# tests helper
# ============
module.exports = (config) ->
	path       = require 'path'
	moduleHelp = require "#{config.paths.abs.test.helpers}/module"

	# constants
	# =========
	FILE_EXT    = path.extname __filename
	BUILD_PATH  = config.paths.abs.root
	BUILDS_PATH = config.paths.abs.test.builds
	TESTS_PATH  = config.paths.abs.test.tests

	# api
	# ===
	get:
		path: (test, loc) -> # loc = abs | rel
			rootPath = BUILD_PATH
			test     = test.replace(rootPath, '').substring 1
			test

		paths: (build, loc) -> # loc = abs | rel
			loc   = config.paths[loc].test.tests
			build = 'default' unless !!build
			tests = require("#{BUILDS_PATH}/api")[build]
			tests = (path.join loc, "#{item}.*" for item in tests)
			tests

		log:
			path: (test) ->
				test = test.replace 'test', ''
				test
	format:
		e: (e) ->
			e.message.replace /\r?\n|\r/g, ''

	run:
		spec: (spec) ->
			specFile = "#{TESTS_PATH}#{spec}-spec#{FILE_EXT}"
			specFile = path.normalize specFile # for windows
			moduleHelp.cache.delete specFile   # for jasmine watch
			require specFile

