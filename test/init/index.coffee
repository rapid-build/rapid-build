module.exports = (config) ->
	# requires
	# ========
	async       = require 'asyncawait/async'
	await       = require 'asyncawait/await'
	jasmine     = require("#{config.paths.abs.test.framework}/jasmine") config
	runTests    = require("#{config.paths.abs.test.tasks}/run-tests")   config, jasmine
	watchTests  = require("#{config.paths.abs.test.tasks}/watch-tests") config, jasmine
	buildConfig = require "#{config.paths.abs.test.tasks}/build-config" # needed for spec files

	# vars
	# ====
	argv  = process.argv
	isDev = !!argv[2] && argv[2].toLowerCase() is 'dev'

	# tasks
	# =====
	runTasks = async ->
		await buildConfig config
		await runTests()
		await watchTests() if isDev

	# return
	# ======
	runTasks()