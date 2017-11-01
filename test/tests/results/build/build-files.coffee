# test results: build-files
# =========================
task    = 'build-files'
fse     = require 'fs-extra'
config  = require "#{process.cwd()}/extra/temp/config.json"
genPath = config.paths.abs.generated.testApp
genDir  = config.pkgs.test.name

# tests
# =====
describe task, ->
	it "should create files.json in generated #{genDir} files dir", (done) ->
		fse.stat "#{genPath}/files/files.json"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e