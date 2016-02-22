module.exports = (config) ->
	# bootstrap
	# =========
	require("#{config.paths.abs.test.bootstrap}/globals") config

	# requires
	# ========
	async      = require 'asyncawait/async'
	await      = require 'asyncawait/await'
	jasmine    = require("#{global.rb.paths.abs.test.framework}/jasmine")()
	runTests   = require("#{global.rb.paths.abs.test.tasks}/run-tests")   jasmine
	watchTests = require("#{global.rb.paths.abs.test.tasks}/watch-tests") jasmine

	# vars
	# ====
	argv  = process.argv
	isDev = !!argv[2] && argv[2].toLowerCase() is 'dev'

	# tasks
	# =====
	runTasks = async ->
		await runTests()
		await watchTests() if isDev

	# return
	# ======
	runTasks()