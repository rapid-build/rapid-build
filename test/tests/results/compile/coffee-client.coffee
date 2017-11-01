# test results: coffee:client
# ===========================
task        = 'coffee:client'
fse         = require 'fs-extra'
config      = require "#{process.cwd()}/extra/temp/config.json"
scriptsPath = config.paths.abs.test.app.dist.client.scripts

# tests
# =====
describe task, ->
	it 'should compile coffee to client dist', (done) ->
		fse.stat "#{scriptsPath}/controllers/home-controller.js"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e