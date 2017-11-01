# test results: coffee:server
# ===========================
task        = 'coffee:server'
fse         = require 'fs-extra'
config      = require "#{process.cwd()}/extra/temp/config.json"
scriptsPath = config.paths.abs.test.app.dist.server.path

# tests
# =====
describe task, ->
	it 'should compile coffee to server dist', (done) ->
		fse.stat "#{scriptsPath}/routes.js"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e