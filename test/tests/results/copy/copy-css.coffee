# test results: copy-css
# ======================
task       = 'copy-css'
fse        = require 'fs-extra'
config     = require "#{process.cwd()}/extra/temp/config.json"
stylesPath = config.paths.abs.test.app.dist.client.styles

# tests
# =====
describe task, ->
	it 'should copy css to dist', (done) ->
		fse.stat "#{stylesPath}/tags/deprecated.css"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e