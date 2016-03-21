# spec: copy-images
# =================
task    = 'copy-images'
async   = require 'asyncawait/async'
await   = require 'asyncawait/await'
Promise = require 'bluebird'
fs      = Promise.promisifyAll require 'fs'
config  = require "#{process.cwd()}/temp/config.json"
imgPath = config.paths.abs.test.app.dist.client.images

# tests
# =====
describe task, ->
	it 'should copy images to dist', async (done) ->
		try stats = await fs.statAsync "#{imgPath}/heroes/heroes.png"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()