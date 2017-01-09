# test results: copy-html
# =======================
task      = 'copy-html'
async     = require 'asyncawait/async'
await     = require 'asyncawait/await'
Promise   = require 'bluebird'
fs        = Promise.promisifyAll require 'fs'
config    = require "#{process.cwd()}/extra/temp/config.json"
tests     = require("#{config.paths.abs.test.helpers}/tests") config
viewsPath = config.paths.abs.test.app.dist.client.views

# tests
# =====
describe task, ->
	appConfig  = undefined

	beforeAll ->
		appConfig  = tests.get.app.config()

	it 'should copy html to dist', async (done) ->
		return done() if config.build.is.prod and appConfig.minify.html.templateCache
		try stats = await fs.statAsync "#{viewsPath}/mains/home.html"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()