# spec: start-server
# ==================
task    = 'start-server'
request = require 'request'
config  = require "#{process.cwd()}/temp/config.json"
tests   = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe task, ->
	port = undefined
	url  = undefined

	beforeAll ->
		port = tests.get.app.config().ports.server
		url  = "http://localhost:#{port}/"

	it 'should start the server', (done) ->
		request url, (e, res, body) ->
			expect(e).toBeFalsy()
			expect(res.statusCode).toBe 200 if res
			done()