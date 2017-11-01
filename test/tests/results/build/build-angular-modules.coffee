# test results: build-angular-modules
# ===================================
task    = 'build-angular-modules'
fse     = require 'fs-extra'
config  = require "#{process.cwd()}/extra/temp/config.json"
genPath = config.paths.abs.generated.testApp

# tests
# =====
describe task, ->
	it 'should create app.coffee', (done) ->
		fse.stat "#{genPath}/src/client/scripts/app.coffee"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e