# test task: set-env-config
# =========================
task   = 'set-env-config'
config = require "#{process.cwd()}/extra/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe task, ->
	tests.test.task.sync task
	tests.test.results "/config/#{task}"
