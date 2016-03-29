# test results: coffee:server
# ===========================
task        = 'coffee:server'
async       = require 'asyncawait/async'
await       = require 'asyncawait/await'
Promise     = require 'bluebird'
fs          = Promise.promisifyAll require 'fs'
config      = require "#{process.cwd()}/temp/config.json"
scriptsPath = config.paths.abs.test.app.dist.server.path

# tests
# =====
describe task, ->
	it 'should compile coffee to server dist', async (done) ->
		try stats = await fs.statAsync "#{scriptsPath}/routes.js"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()