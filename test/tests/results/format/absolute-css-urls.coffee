# test results: absolute-css-urls
# ===============================
task       = 'absolute-css-urls'
async      = require 'asyncawait/async'
await      = require 'asyncawait/await'
Promise    = require 'bluebird'
fs         = Promise.promisifyAll require 'fs'
config     = require "#{process.cwd()}/extra/temp/config.json"
stylesPath = config.paths.abs.test.app.dist.client.styles

# tests
# =====
describe task, ->
	it 'should convert css urls from relative to absolute', async (done) ->
		url = '/images/heroes/heroes.png'
		try result = await fs.readFileAsync "#{stylesPath}/app-less.css"
		result = result.toString().indexOf(url) isnt -1 if result
		expect(result).toBeTrue()
		done()