# test results: build-bower-json
# ==============================
task    = 'build-bower-json'
async   = require 'asyncawait/async'
await   = require 'asyncawait/await'
Promise = require 'bluebird'
fs      = Promise.promisifyAll require 'fs'
config  = require "#{process.cwd()}/extra/temp/config.json"
path    = require 'path'
genPath = path.join config.paths.abs.generated.testApp, 'src', 'client'

# tests
# =====
describe task, ->
	it 'should create bower.json', async (done) ->
		try stats = await fs.statAsync "#{genPath}/bower.json"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()