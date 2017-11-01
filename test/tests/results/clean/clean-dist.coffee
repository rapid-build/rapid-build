# test results: clean-dist
# ========================
task     = 'clean-dist'
fse      = require 'fs-extra'
config   = require "#{process.cwd()}/extra/temp/config.json"
distPath = config.paths.abs.test.app.dist.path

# tests
# =====
describe task, ->
	it 'should delete dist dir', (done) ->
		fse.stat distPath
		.then (stats) ->
			expect(stats.isDirectory()).toBeFalse()
			done()
		.catch (e) ->
			expect(e.code.toLowerCase()).toContain 'enoent'
			done()