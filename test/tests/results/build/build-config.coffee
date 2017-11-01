# test results: build-config
# ==========================
task    = 'build-config'
fse     = require 'fs-extra'
config  = require "#{process.cwd()}/extra/temp/config.json"
genPath = config.paths.abs.generated.testApp

# tests
# =====
describe task, ->
	it 'should create config.json', (done) ->
		fse.stat "#{genPath}/config.json"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e