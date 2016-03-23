# spec: start-server
# ==================
task    = 'start-server'
async   = require 'asyncawait/async'
await   = require 'asyncawait/await'
Promise = require 'bluebird'
fs      = Promise.promisifyAll require 'fs'
config  = require "#{process.cwd()}/temp/config.json"
appPath = config.paths.abs.test.app.dist.client.path

# tests (TODO)
# ============
# describe task, ->
# 	it 'should start the server', async (done) ->
# 		# console.log 'spec start-server'.attn
# 		try stats = await fs.statAsync "#{appPath}/spa.html"
# 		result = stats?.isFile()
# 		expect(result).toBeTrue()
# 		done()
