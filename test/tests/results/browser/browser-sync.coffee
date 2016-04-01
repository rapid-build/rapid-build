# test results: browser-sync
# ==========================
task    = 'browser-sync'
request = require 'request'
config  = require "#{process.cwd()}/extra/temp/config.json"
tests   = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe task, ->
	port = undefined
	url  = undefined

	beforeAll ->
		port = tests.get.app.config().ports.reload
		url  = "http://localhost:#{port}/"

	it 'should proxy the server', (done) ->
		request url, (e, res, body) ->
			expect(e).toBeFalsy()
			expect(res.statusCode).toBe 200 if res
			done()