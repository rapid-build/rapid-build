module.exports = (pkgRoot) ->
	q = require 'q'
	require("#{pkgRoot}/extra/tasks/add-colors")()

	# get config then build it (synchronously), specs use it
	# ======================================================
	config = require("#{pkgRoot}/test/config/config") pkgRoot
	require("#{config.paths.abs.extra.tasks}/build-config") config

	# helpers
	# =======
	Timer = require "#{config.paths.abs.test.helpers}/Timer"

	# testing framework
	# =================
	jasmine = require("#{config.paths.abs.test.framework}/jasmine") config

	# tasks
	# =====
	TASKS_PATH      = config.paths.abs.test.tasks
	runTests        = require("#{TASKS_PATH}/run-tests")   config, jasmine
	watchTests      = require("#{TASKS_PATH}/watch-tests") config, jasmine
	addBuildEnvVars = require "#{TASKS_PATH}/add-build-env-vars"

	# tasks in order
	# ==============
	runTasks = -> # sync
		defer = q.defer()
		# timer = undefined
		tasks = [
			-> addBuildEnvVars config
			# -> timer = new Timer 'runTests', true
			-> runTests()
			# -> timer.clear true
			-> watchTests() if config.test.watch
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# return
	# ======
	runTasks()