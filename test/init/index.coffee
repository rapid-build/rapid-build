module.exports = (pkgRoot) ->
	async = require 'asyncawait/async'
	await = require 'asyncawait/await'

	# get config then build it (synchronously), specs use it
	# ======================================================
	config = require("#{pkgRoot}/test/config/config") pkgRoot
	require("#{config.paths.abs.core.tasks}/build-config") config

	# helpers
	# =======
	Timer = require "#{config.paths.abs.test.helpers}/Timer"

	# testing framework
	# =================
	jasmine = require("#{config.paths.abs.test.framework}/jasmine") config

	# tasks
	# =====
	TASKS_PATH     = config.paths.abs.test.tasks
	runTests       = require("#{TASKS_PATH}/run-tests")   config, jasmine
	watchTests     = require("#{TASKS_PATH}/watch-tests") config, jasmine
	addBuildEnvVar = require "#{TASKS_PATH}/add-build-env-var"

	# tasks in order
	# ==============
	runTasks = async ->
		await addBuildEnvVar config
		# timer = new Timer 'runTests', true
		await runTests()
		# timer.clear true
		await watchTests() if config.test.watch

	# return
	# ======
	runTasks()