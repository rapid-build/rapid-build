# spec: common
# ============
task   = 'common-client'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} tasks", ->
	tests.run.spec '/build/build-bower-json'
	tests.run.spec '/copy/copy-images'
	tests.run.spec '/copy/copy-js'
	tests.run.spec '/compile/coffee'
	tests.run.spec '/compile/es6'


