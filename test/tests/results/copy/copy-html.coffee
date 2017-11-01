# test results: copy-html
# =======================
task      = 'copy-html'
fse       = require 'fs-extra'
config    = require "#{process.cwd()}/extra/temp/config.json"
tests     = require("#{config.paths.abs.test.helpers}/tests") config
viewsPath = config.paths.abs.test.app.dist.client.views

# tests
# =====
describe task, ->
	appConfig  = undefined

	beforeAll ->
		appConfig = tests.get.app.config()

	it 'should copy html to dist', (done) ->
		return done() if config.build.is.prod and appConfig.minify.html.templateCache

		fse.stat "#{viewsPath}/mains/home.html"
		.then (stats) ->
			expect(stats.isFile()).toBeTrue()
			done()
		.catch (e) ->
			done.fail e