# test results: build-bower-json
# ==============================
task    = 'build-bower-json'
fse     = require 'fs-extra'
config  = require "#{process.cwd()}/extra/temp/config.json"
path    = require 'path'
genPath = path.join config.paths.abs.generated.testApp, 'src', 'client'

# tests
# =====
describe task, ->
	it 'should create bower.json', (done) ->
		fse.stat "#{genPath}/bower.json"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e