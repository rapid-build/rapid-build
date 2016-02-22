# tests helper
# ============
module.exports =
	get:
		path: (test, loc) -> # loc = abs | rel
			rootPath = global.rb.paths.abs.root
			test     = test.replace(rootPath, '').substring 1
			test

		paths: (build, loc) -> # loc = abs | rel
			path  = require 'path'
			loc   = global.rb.paths[loc].test.tests
			tests = require "#{global.rb.paths.abs.test.builds}/#{build}"
			tests = (path.join loc, "#{item}.*" for item in tests)
			tests

		log:
			path: (test) ->
				test = test.replace 'test', ''
				test

