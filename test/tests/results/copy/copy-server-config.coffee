# test results: copy-server-config
# ================================
task         = 'copy-server-config'
fse          = require 'fs-extra'
config       = require "#{process.cwd()}/extra/temp/config.json"
rbServerPath = config.paths.abs.test.app.dist.server.build
rbDirName    = config.pkgs.rb.name

# tests
# =====
describe task, ->
	msg1 = "should copy config.json to server dist #{rbDirName} dir"
	it msg1, (done) ->
		fse.stat "#{rbServerPath}/config.json"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e