# test results: generate-pkg
# ==========================
task    = 'generate-pkg'
async   = require 'asyncawait/async'
await   = require 'asyncawait/await'
Promise = require 'bluebird'
fs      = Promise.promisifyAll require 'fs'
config  = require "#{process.cwd()}/temp/config.json"
genPath = config.paths.abs.generated.testApp
genDir  = config.pkgs.test.name

# tests
# =====
describe task, ->
	it "should create #{genDir} dir in generated dir", async (done) ->
		try stats = await fs.statAsync genPath
		result = stats?.isDirectory()
		expect(result).toBeDefined()
		done()