# test results: copy-bower_components
# ===================================
task           = 'copy-bower_components'
fse            = require 'fs-extra'
config         = require "#{process.cwd()}/extra/temp/config.json"
buildPkgName   = config.pkgs.rb.name
bowerDir       = 'bower_components'
buildBowerPath = "#{config.paths.abs.test.app.dist.client.path}/#{buildPkgName}/#{bowerDir}"

# tests
# =====
describe task, ->
	it "should create #{bowerDir} dir in client dist #{buildPkgName} dir", (done) ->
		fse.stat buildBowerPath
		.then (stats) ->
			expect(stats.isDirectory()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e