# spec: common
# ============
task   = 'common'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} tasks", ->
	tests.run.spec '/config/set-env-config'
	tests.run.spec '/clean/clean-dist'
	tests.run.spec '/generate/generate-pkg'
	tests.run.spec '/build/build-config'


