# test results: less
# ==================
task       = 'less'
fse        = require 'fs-extra'
config     = require "#{process.cwd()}/extra/temp/config.json"
stylesPath = config.paths.abs.test.app.dist.client.styles

# tests
# =====
describe task, ->
	it 'should compile less to client dist', (done) ->
		fse.stat "#{stylesPath}/app-less.css"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e