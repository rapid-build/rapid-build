# test results: es6:server
# ========================
task        = 'es6:server'
fse     = require 'fs-extra'
config      = require "#{process.cwd()}/extra/temp/config.json"
scriptsPath = config.paths.abs.test.app.dist.server.path

# tests
# =====
describe task, ->
	it 'should compile es6 to server dist', (done) ->
		fse.stat "#{scriptsPath}/data/heroes.js"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e