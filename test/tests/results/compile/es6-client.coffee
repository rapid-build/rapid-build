# test results: es6:client
# ========================
task        = 'es6:client'
async       = require 'asyncawait/async'
await       = require 'asyncawait/await'
Promise     = require 'bluebird'
fs          = Promise.promisifyAll require 'fs'
config      = require "#{process.cwd()}/temp/config.json"
scriptsPath = config.paths.abs.test.app.dist.client.scripts

# tests
# =====
describe task, ->
	it 'should compile es6 to client dist', async (done) ->
		try stats = await fs.statAsync "#{scriptsPath}/configs/router.js"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()