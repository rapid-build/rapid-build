# spec: build-config
# ==================
task    = 'build-config'
async   = require 'asyncawait/async'
await   = require 'asyncawait/await'
Promise = require 'bluebird'
fs      = Promise.promisifyAll require 'fs'
config  = require "#{process.cwd()}/temp/config.json"
genPath = config.paths.abs.generated.testApp

# tests
# =====
describe task, ->
	it 'should create config.json', async (done) ->
		try stats = await fs.statAsync "#{genPath}/config.json"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()