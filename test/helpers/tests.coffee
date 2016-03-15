# tests helper
# ============
module.exports = (config) ->
	get:
		path: (test, loc) -> # loc = abs | rel
			rootPath = config.paths.abs.root
			test     = test.replace(rootPath, '').substring 1
			test

		paths: (build, loc) -> # loc = abs | rel
			path  = require 'path'
			loc   = config.paths[loc].test.tests
			tests = require "#{config.paths.abs.test.builds}/#{build}"
			tests = (path.join loc, "#{item}.*" for item in tests)
			tests

		log:
			path: (test) ->
				test = test.replace 'test', ''
				test

