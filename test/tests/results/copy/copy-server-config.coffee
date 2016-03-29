# test results: copy-server-config
# ================================
task         = 'copy-server-config'
async        = require 'asyncawait/async'
await        = require 'asyncawait/await'
Promise      = require 'bluebird'
fs           = Promise.promisifyAll require 'fs'
config       = require "#{process.cwd()}/temp/config.json"
rbServerPath = config.paths.abs.test.app.dist.server.build
rbDirName    = config.pkgs.rb.name

# tests
# =====
describe task, ->
	msg1 = "should copy config.json to server dist #{rbDirName} dir"
	it msg1, async (done) ->
		try stats = await fs.statAsync "#{rbServerPath}/config.json"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()