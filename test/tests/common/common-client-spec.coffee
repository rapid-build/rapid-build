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
	tests.run.spec '/build/build-angular-modules'
	tests.run.spec '/copy/copy-images'
	tests.run.spec '/copy/copy-js:client'
	tests.run.spec '/compile/coffee:client'
	tests.run.spec '/compile/es6:client'


