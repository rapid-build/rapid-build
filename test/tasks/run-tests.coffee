# run-tests
# =========
module.exports = (config, jasmine) ->
	testsHelper = require("#{config.paths.abs.test.helpers}/tests") config
	tests       = testsHelper.get.paths config.build.mode, 'rel'

	# task
	# ====
	runTask = ->
		jasmine.init(tests).execute() # returns promise

	# return
	# ======
	runTask

