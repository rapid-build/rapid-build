# spec: copy-js:server
# ====================
task        = 'copy-js:server'
async       = require 'asyncawait/async'
await       = require 'asyncawait/await'
Promise     = require 'bluebird'
fs          = Promise.promisifyAll require 'fs'
config      = require "#{process.cwd()}/temp/config.json"
scriptsPath = config.paths.abs.test.app.dist.server.path

# tests
# =====
describe task, ->
	it 'should copy js to server dist', async (done) ->
		try stats = await fs.statAsync "#{scriptsPath}/data/villains.js"
		result = stats?.isFile()
		expect(result).toBeDefined()
		done()