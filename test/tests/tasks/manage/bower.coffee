# test task: bower
# ================
task   = 'bower'
config = require "#{process.cwd()}/extra/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} task", ->
	tests.test.task.sync task
	tests.test.results "/manage/#{task}"
