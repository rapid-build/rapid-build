# spec: sass
# ==========
task       = 'sass'
async      = require 'asyncawait/async'
await      = require 'asyncawait/await'
Promise    = require 'bluebird'
fs         = Promise.promisifyAll require 'fs'
config     = require "#{process.cwd()}/temp/config.json"
stylesPath = config.paths.abs.test.app.dist.client.styles

# tests
# =====
describe task, ->
	it 'should compile sass to client dist', async (done) ->
		try stats = await fs.statAsync "#{stylesPath}/app-sass.css"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()