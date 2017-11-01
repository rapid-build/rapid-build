# test results: copy-js:client
# ============================
task        = 'copy-js:client'
fse         = require 'fs-extra'
config      = require "#{process.cwd()}/extra/temp/config.json"
scriptsPath = config.paths.abs.test.app.dist.client.scripts

# tests
# =====
describe task, ->
	it 'should copy js to client dist', (done) ->
		fse.stat "#{scriptsPath}/values/heroes.js"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e