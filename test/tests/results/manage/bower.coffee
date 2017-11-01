# test results: bower
# ===================
task           = 'bower'
fse            = require 'fs-extra'
config         = require "#{process.cwd()}/extra/temp/config.json"
genPath        = config.paths.abs.generated.testApp
genDir         = config.pkgs.test.name
genBowerDir    = 'bower_components'
genBowerPath   = "#{genPath}/src/client/#{genBowerDir}"
genAngularPath = "#{genBowerPath}/angular"

# tests
# =====
describe task, ->
	it "should create #{genBowerDir} dir in generated #{genDir} src client dir", (done) ->
		fse.stat genBowerPath
		.then (stats) ->
			expect(stats.isDirectory()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e

	it "should create angular dir inside generated #{genBowerDir} dir", (done) ->
		fse.stat genAngularPath
		.then (stats) ->
			expect(stats.isDirectory()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e