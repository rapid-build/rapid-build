# run-tests
# =========
module.exports = (config, jasmine) ->
	tests      = require("#{config.paths.abs.test.helpers}/tests") config
	api        = "#{config.paths.abs.test.init}/api"
	buildMode  = config.build.mode
	buildMode  = 'default' unless buildMode
	buildTasks = require(api)[buildMode]
	specs      = tests.get.tests buildTasks, 'tasks'

	# task
	# ====
	runTask = ->
		jasmine.init(specs).execute() # returns promise

	# return
	# ======
	runTask

