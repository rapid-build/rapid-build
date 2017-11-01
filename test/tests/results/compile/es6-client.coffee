# test results: es6:client
# ========================
task        = 'es6:client'
fse         = require 'fs-extra'
config      = require "#{process.cwd()}/extra/temp/config.json"
scriptsPath = config.paths.abs.test.app.dist.client.scripts

# tests
# =====
describe task, ->
	it 'should compile es6 to client dist', (done) ->
		fse.stat "#{scriptsPath}/configs/router.js"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e