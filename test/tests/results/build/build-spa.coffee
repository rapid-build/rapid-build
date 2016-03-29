# test results: build-spa
# =======================
task    = 'build-spa'
async   = require 'asyncawait/async'
await   = require 'asyncawait/await'
Promise = require 'bluebird'
fs      = Promise.promisifyAll require 'fs'
config  = require "#{process.cwd()}/extra/temp/config.json"
appPath = config.paths.abs.test.app.dist.client.path

# tests
# =====
describe task, ->
	if config.build.options.exclude
		it 'should not create client dist spa.html if build option.exclude.spa is true', async (done) ->
			try stats = await fs.statAsync "#{appPath}/spa.html"
			result = stats?.isFile() or false
			expect(result).toBeFalse()
			done()
	else
		it 'should create client dist spa.html', async (done) ->
			try stats = await fs.statAsync "#{appPath}/spa.html"
			result = stats?.isFile()
			expect(result).toBeTrue()
			done()