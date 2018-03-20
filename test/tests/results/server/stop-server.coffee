# test results: stop-server
# =========================
task    = 'stop-server'
request = require 'request'
config  = require "#{process.cwd()}/extra/temp/config.json"
tests   = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe task, ->
	port = undefined
	url  = undefined

	beforeAll ->
		port = tests.get.app.config().ports.server
		url  = "http://localhost:#{port}/"

	it 'should stop the server', (done) ->
		request url, (e, res, body) ->
			expect(e.code.toLowerCase()).toContain 'econnrefused'
			done()