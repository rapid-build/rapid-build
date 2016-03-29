# test results: clean-dist
# ========================
task     = 'clean-dist'
async    = require 'asyncawait/async'
await    = require 'asyncawait/await'
Promise  = require 'bluebird'
fs       = Promise.promisifyAll require 'fs'
config   = require "#{process.cwd()}/temp/config.json"
distPath = config.paths.abs.test.app.dist.path

# tests
# =====
describe task, ->
	it 'should delete dist dir', async (done) ->
		try stats = await fs.statAsync distPath
		result = stats?.isDirectory()
		expect(result).not.toBeDefined()
		done()