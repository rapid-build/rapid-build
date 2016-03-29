# test results: common-client
# ===========================
task   = 'common-client'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} tasks", ->
	tests.test.results '/config/update-angular-mocks-config'
	tests.test.results '/build/build-bower-json'
	tests.test.results '/manage/bower'
	tests.test.results '/build/build-angular-modules'
	tests.test.results '/copy/copy-bower_components'
	tests.test.results '/copy/copy-css'
	tests.test.results '/copy/copy-images'
	tests.test.results '/copy/copy-js:client'
	tests.test.results '/copy/copy-libs'
	tests.test.results '/copy/copy-views'
	tests.test.results '/compile/coffee:client'
	tests.test.results '/compile/es6:client'
	tests.test.results '/compile/less'
	tests.test.results '/compile/sass'
	tests.test.results '/format/absolute-css-urls'
	tests.test.results '/clean/clean-rb-client'
	tests.test.results '/build/build-files'


