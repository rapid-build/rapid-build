# test results: generate-pkg
# ==========================
task    = 'generate-pkg'
fse     = require 'fs-extra'
config  = require "#{process.cwd()}/extra/temp/config.json"
genPath = config.paths.abs.generated.testApp
genDir  = config.pkgs.test.name

# tests
# =====
describe task, ->
	it "should create #{genDir} dir in generated dir", (done) ->
		fse.stat genPath
		.then (stats) ->
			expect(stats.isDirectory()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e