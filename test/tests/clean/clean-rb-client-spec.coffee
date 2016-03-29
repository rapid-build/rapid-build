# spec: clean-rb-client
# =====================
task         = 'clean-rb-client'
async        = require 'asyncawait/async'
await        = require 'asyncawait/await'
Promise      = require 'bluebird'
fs           = Promise.promisifyAll require 'fs'
config       = require "#{process.cwd()}/temp/config.json"
tests        = require("#{config.paths.abs.test.helpers}/tests") config
appConfig    = tests.get.app.config()
rbDirName    = appConfig.rb.prefix.distDir
rbClientPath = config.paths.abs.test.app.dist.client.build

# tests
# =====
describe task, ->
	if appConfig.exclude.default.client.files
		msg  = "should delete client dist #{rbDirName} dir "
		msg += "if build option exclude.default.client.files is true"
		it msg, async (done) ->
			try stats = await fs.statAsync rbClientPath
			result = stats?.isDirectory()
			expect(result).not.toBeDefined()
			done()
	else
		msg  = "should not delete client dist #{rbDirName} dir "
		msg += "if build option exclude.default.client.files is false"
		it msg, async (done) ->
			try stats = await fs.statAsync rbClientPath
			result = stats?.isDirectory()
			expect(result).toBeDefined()
			done()