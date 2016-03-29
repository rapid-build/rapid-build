# spec: build-files
# =================
task    = 'build-files'
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
	it "should create files.json in generated #{genDir} files dir", async (done) ->
		try stats = await fs.statAsync "#{genPath}/files/files.json"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()