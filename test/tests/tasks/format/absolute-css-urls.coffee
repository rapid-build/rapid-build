# test task: absolute-css-urls
# ============================
task   = 'absolute-css-urls'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} task", ->
	tests.test.task.sync task
	tests.test.results "/format/#{task}"
