# test results: build-angular-modules
# ===================================
task    = 'build-angular-modules'
async   = require 'asyncawait/async'
await   = require 'asyncawait/await'
Promise = require 'bluebird'
fs      = Promise.promisifyAll require 'fs'
config  = require "#{process.cwd()}/extra/temp/config.json"
genPath = config.paths.abs.generated.testApp

# tests
# =====
describe task, ->
	it 'should create app.coffee', async (done) ->
		try stats = await fs.statAsync "#{genPath}/src/client/scripts/app.coffee"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()