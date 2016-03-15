# run-tests
# =========
module.exports = (config, jasmine) ->
	# requires
	# ========
	path        = require 'path'
	testsHelper = require("#{config.paths.abs.test.helpers}/tests") config

	# test files
	# ==========
	tests = testsHelper.get.paths 'default', 'rel'

	# task
	# ====
	runTask = ->
		jasmine.init(tests).execute() # returns promise

	# return
	# ======
	runTask

