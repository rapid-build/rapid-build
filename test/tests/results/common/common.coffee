# test results: common
# ====================
task   = 'common'
config = require "#{process.cwd()}/extra/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} tasks", ->
	tests.test.results '/config/set-env-config'
	tests.test.results '/clean/clean-dist'
	tests.test.results '/generate/generate-pkg'
	tests.test.results '/build/build-config'


