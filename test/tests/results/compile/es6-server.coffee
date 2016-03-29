# test results: es6:server
# ========================
task        = 'es6:server'
async       = require 'asyncawait/async'
await       = require 'asyncawait/await'
Promise     = require 'bluebird'
fs          = Promise.promisifyAll require 'fs'
config      = require "#{process.cwd()}/temp/config.json"
scriptsPath = config.paths.abs.test.app.dist.server.path

# tests
# =====
describe task, ->
	it 'should compile es6 to server dist', async (done) ->
		try stats = await fs.statAsync "#{scriptsPath}/data/heroes.js"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()