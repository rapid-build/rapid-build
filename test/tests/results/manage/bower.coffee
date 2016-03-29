# test results: bower
# ===================
task           = 'bower'
async          = require 'asyncawait/async'
await          = require 'asyncawait/await'
Promise        = require 'bluebird'
fs             = Promise.promisifyAll require 'fs'
config         = require "#{process.cwd()}/temp/config.json"
genPath        = config.paths.abs.generated.testApp
genDir         = config.pkgs.test.name
genBowerDir    = 'bower_components'
genBowerPath   = "#{genPath}/src/client/#{genBowerDir}"
genAngularPath = "#{genBowerPath}/angular"

# tests
# =====
describe task, ->
	it "should create #{genBowerDir} dir in generated #{genDir} src client dir", async (done) ->
		try stats = await fs.statAsync genBowerPath
		result = stats?.isDirectory()
		expect(result).toBeDefined()
		done()

	it "should create angular dir inside generated #{genBowerDir} dir", async (done) ->
		try stats = await fs.statAsync genAngularPath
		result = stats?.isDirectory()
		expect(result).toBeDefined()
		done()