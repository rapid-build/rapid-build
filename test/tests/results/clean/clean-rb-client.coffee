# test results: clean-rb-client
# =============================
task         = 'clean-rb-client'
async        = require 'asyncawait/async'
await        = require 'asyncawait/await'
Promise      = require 'bluebird'
fs           = Promise.promisifyAll require 'fs'
config       = require "#{process.cwd()}/temp/config.json"
tests        = require("#{config.paths.abs.test.helpers}/tests") config
rbClientPath = config.paths.abs.test.app.dist.client.build
rbDirName    = config.pkgs.rb.name

# tests
# =====
describe task, ->
	appConfig = undefined

	beforeAll ->
		appConfig = tests.get.app.config()

	msg1  = "should delete client dist #{rbDirName} dir "
	msg1 += "if build option exclude.default.client.files is true"
	it msg1, async (done) ->
		return done() unless appConfig.exclude.default.client.files
		try stats = await fs.statAsync rbClientPath
		result = stats?.isDirectory()
		expect(result).not.toBeDefined()
		done()

	msg2  = "should not delete client dist #{rbDirName} dir "
	msg2 += "if build option exclude.default.client.files is false"
	it msg2, async (done) ->
		return done() if appConfig.exclude.default.client.files
		try stats = await fs.statAsync rbClientPath
		result = stats?.isDirectory()
		expect(result).toBeDefined()
		done()