# test results: copy-libs
# =======================
task     = 'copy-libs'
fse      = require 'fs-extra'
config   = require "#{process.cwd()}/extra/temp/config.json"
libsPath = config.paths.abs.test.app.dist.client.libs

# tests
# =====
describe task, ->
	it 'should copy libs to dist', (done) ->
		fse.stat "#{libsPath}/is/is.js"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e