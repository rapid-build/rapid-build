# test results: copy-views
# ========================
task   = 'copy-views'
config = require "#{process.cwd()}/extra/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe task, ->
	tests.test.results '/copy/copy-html'


