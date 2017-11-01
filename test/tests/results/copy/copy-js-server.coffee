# test results: copy-js:server
# ============================
task        = 'copy-js:server'
fse         = require 'fs-extra'
config      = require "#{process.cwd()}/extra/temp/config.json"
scriptsPath = config.paths.abs.test.app.dist.server.path

# tests
# =====
describe task, ->
	it 'should copy js to server dist', (done) ->
		fse.stat "#{scriptsPath}/data/villains.js"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e