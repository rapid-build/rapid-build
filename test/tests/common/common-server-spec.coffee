# spec: common-server
# ===================
task   = 'common-server'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} tasks", ->
	tests.run.spec '/copy/copy-js:server'
	tests.run.spec '/compile/coffee:server'
	tests.run.spec '/compile/es6:server'


