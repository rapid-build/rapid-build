# spec: start-server
# ==================
task    = 'start-server'
request = require 'request'
config  = require "#{process.cwd()}/temp/config.json"
tests   = require("#{config.paths.abs.test.helpers}/tests") config
appPath = config.paths.abs.test.app.dist.client.path
port    = tests.get.app.config().ports.server
url     = "http://localhost:#{port}/"

# tests
# =====
describe task, ->
	it 'should start the server', (done) ->
		request url, (e, res, body) ->
			expect(e).toBeFalsy()
			expect(res.statusCode).toBe 200 if res
			done()