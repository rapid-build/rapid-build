# test results: copy-html
# =======================
task      = 'copy-html'
async     = require 'asyncawait/async'
await     = require 'asyncawait/await'
Promise   = require 'bluebird'
fs        = Promise.promisifyAll require 'fs'
config    = require "#{process.cwd()}/extra/temp/config.json"
viewsPath = config.paths.abs.test.app.dist.client.views

# tests
# =====
describe task, ->
	it 'should copy html to dist', async (done) ->
		try stats = await fs.statAsync "#{viewsPath}/mains/home.html"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()