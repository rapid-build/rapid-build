# test results: copy-libs
# =======================
task     = 'copy-libs'
async    = require 'asyncawait/async'
await    = require 'asyncawait/await'
Promise  = require 'bluebird'
fs       = Promise.promisifyAll require 'fs'
config   = require "#{process.cwd()}/extra/temp/config.json"
libsPath = config.paths.abs.test.app.dist.client.libs

# tests
# =====
describe task, ->
	it 'should copy libs to dist', async (done) ->
		try stats = await fs.statAsync "#{libsPath}/is/is.js"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()