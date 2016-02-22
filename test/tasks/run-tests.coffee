# run-tests
# =========
module.exports = (jasmine) ->
	# requires
	# ========
	path = require 'path'

	# test files
	# ==========
	testsRel = global.rb.paths.rel.test.tests
	tests    = path.join testsRel, '**', '*.*'

	# task
	# ====
	runTask = ->
		jasmine.init(tests).execute() # returns promist

	# return
	# ======
	runTask

