module.exports = (config) ->
	async = require 'asyncawait/async'
	await = require 'asyncawait/await'

	# helpers
	# =======
	Timer = require "#{config.paths.abs.test.helpers}/Timer"

	# testing framework
	# =================
	jasmine = require("#{config.paths.abs.test.framework}/jasmine") config

	# tasks
	# =====
	TASKS_PATH     = config.paths.abs.test.tasks
	config.build   = require("#{TASKS_PATH}/build-info")  process.argv
	runTests       = require("#{TASKS_PATH}/run-tests")   config, jasmine
	watchTests     = require("#{TASKS_PATH}/watch-tests") config, jasmine
	buildConfig    = require "#{TASKS_PATH}/build-config" # needed for spec files
	addBuildEnvVar = require "#{TASKS_PATH}/add-build-env-var"

	# tasks in order
	# ==============
	runTasks = async ->
		await(
			addBuildEnvVar config
			buildConfig config
		)
		# timer = new Timer 'runTests', true
		await runTests()
		# timer.clear true
		await watchTests() if config.build.watchTests

	# return
	# ======
	runTasks()