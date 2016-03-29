# spec: common-client
# ===================
task   = 'common-client'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} tasks", ->
	tests.run.spec '/config/update-angular-mocks-config'
	tests.run.spec '/build/build-bower-json'
	tests.run.spec '/manage/bower'
	tests.run.spec '/build/build-angular-modules'
	tests.run.spec '/copy/copy-bower_components'
	tests.run.spec '/copy/copy-css'
	tests.run.spec '/copy/copy-images'
	tests.run.spec '/copy/copy-js:client'
	tests.run.spec '/copy/copy-libs'
	tests.run.spec '/copy/copy-views'
	tests.run.spec '/compile/coffee:client'
	tests.run.spec '/compile/es6:client'
	tests.run.spec '/compile/less'
	tests.run.spec '/compile/sass'
	tests.run.spec '/format/absolute-css-urls'
	tests.run.spec '/clean/clean-rb-client'
	tests.run.spec '/build/build-files'


