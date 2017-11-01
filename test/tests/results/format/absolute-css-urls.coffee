# test results: absolute-css-urls
# ===============================
task       = 'absolute-css-urls'
fse        = require 'fs-extra'
config     = require "#{process.cwd()}/extra/temp/config.json"
stylesPath = config.paths.abs.test.app.dist.client.styles

# tests
# =====
describe task, ->
	it 'should convert css urls from relative to absolute', (done) ->
		url = '/images/heroes/heroes.png'
		fse.readFile "#{stylesPath}/app-less.css"
		.then (result) ->
			result = result.toString().indexOf(url) isnt -1 if result
			expect(result).toBeTrue()
			done()
		.catch (e) ->
			done.fail e