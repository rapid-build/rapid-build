# test task: clean-rb-client
# ==========================
task   = 'clean-rb-client'
config = require "#{process.cwd()}/extra/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe task, ->
	tests.test.task.sync task
	tests.test.results "/clean/#{task}"
