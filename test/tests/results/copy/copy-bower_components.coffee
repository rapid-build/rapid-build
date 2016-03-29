# test results: copy-bower_components
# ===================================
task           = 'copy-bower_components'
async          = require 'asyncawait/async'
await          = require 'asyncawait/await'
Promise        = require 'bluebird'
fs             = Promise.promisifyAll require 'fs'
config         = require "#{process.cwd()}/temp/config.json"
buildPkgName   = config.pkgs.rb.name
bowerDir       = 'bower_components'
buildBowerPath = "#{config.paths.abs.test.app.dist.client.path}/#{buildPkgName}/#{bowerDir}"

# tests
# =====
describe task, ->
	it "should create #{bowerDir} dir in client dist #{buildPkgName} dir", async (done) ->
		try stats = await fs.statAsync buildBowerPath
		result = stats?.isDirectory()
		expect(result).toBeDefined()
		done()