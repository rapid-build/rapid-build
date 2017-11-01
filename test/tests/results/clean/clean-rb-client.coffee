# test results: clean-rb-client
# =============================
task         = 'clean-rb-client'
fse          = require 'fs-extra'
config       = require "#{process.cwd()}/extra/temp/config.json"
tests        = require("#{config.paths.abs.test.helpers}/tests") config
rbClientPath = config.paths.abs.test.app.dist.client.build
rbDirName    = config.pkgs.rb.name

# tests
# =====
describe task, ->
	appConfig = undefined

	beforeAll ->
		appConfig = tests.get.app.config()

	msg1  = "should delete client dist #{rbDirName} dir "
	msg1 += "if build option exclude.default.client.files is true"
	it msg1, (done) ->
		return done() unless appConfig.exclude.default.client.files
		fse.stat rbClientPath
		.then (stats) ->
			expect(stats.isDirectory()).toBeFalse()
			done()
		.catch (e) ->
			expect(e.code.toLowerCase()).toContain 'enoent'
			done()

	msg2  = "should not delete client dist #{rbDirName} dir "
	msg2 += "if build option exclude.default.client.files is false"
	it msg2, (done) ->
		return done() if appConfig.exclude.default.client.files

		fse.stat rbClientPath
		.then (stats) ->
			expect(stats.isDirectory()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e