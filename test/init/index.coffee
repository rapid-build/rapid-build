module.exports = (config) ->
	# requires
	# ========
	async        = require 'asyncawait/async'
	await        = require 'asyncawait/await'
	jasmine      = require("#{config.paths.abs.test.framework}/jasmine") config
	runTests     = require("#{config.paths.abs.test.tasks}/run-tests")   config, jasmine
	watchTests   = require("#{config.paths.abs.test.tasks}/watch-tests") config, jasmine
	buildConfig  = require "#{config.paths.abs.test.tasks}/build-config" # needed for spec files
	config.build = require("#{config.paths.abs.test.tasks}/build-info")  process.argv

	# tasks
	# =====
	runTasks = async ->
		await buildConfig config
		await runTests()
		await watchTests() if config.build.watchTests

	# return
	# ======
	runTasks()