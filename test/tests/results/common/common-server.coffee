# test results: common-server
# ===========================
task   = 'common-server'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} tasks", ->
	tests.test.results '/copy/copy-js:server'
	tests.test.results '/compile/coffee:server'
	tests.test.results '/compile/es6:server'
	tests.test.results '/copy/copy-server-config'


