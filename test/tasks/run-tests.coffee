# run-tests
# =========
module.exports = (jasmine) ->
	# requires
	# ========
	path        = require 'path'
	testsHelper = require "#{global.rb.paths.abs.test.helpers}/tests"

	# test files
	# ==========
	tests = testsHelper.get.paths 'default', 'rel'

	# task
	# ====
	runTask = ->
		jasmine.init(tests).execute() # returns promist

	# return
	# ======
	runTask

