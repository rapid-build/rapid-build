# test results: copy-images
# =========================
task    = 'copy-images'
fse     = require 'fs-extra'
config  = require "#{process.cwd()}/extra/temp/config.json"
imgPath = config.paths.abs.test.app.dist.client.images

# tests
# =====
describe task, ->
	it 'should copy images to dist', (done) ->
		fse.stat "#{imgPath}/heroes/heroes.png"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e