# test results: build-spa
# =======================
task    = 'build-spa'
fse     = require 'fs-extra'
config  = require "#{process.cwd()}/extra/temp/config.json"
appPath = config.paths.abs.test.app.dist.client.path

# tests
# =====
describe task, ->
	if config.build.options.exclude
		it 'should not create client dist spa.html if build option.exclude.spa is true', (done) ->
			fse.stat "#{appPath}/spa.html"
			.then (stats) ->
				expect(stats.isFile()).toBeFalse()
				done()
			.catch (e) ->
				expect(e.code.toLowerCase()).toContain 'enoent'
				done()
	else
		it 'should create client dist spa.html', (done) ->
			fse.stat "#{appPath}/spa.html"
			.then (stats) ->
				expect(stats.isFile()).toBeTrue()
				done()
			.catch (e) ->
				done.fail e