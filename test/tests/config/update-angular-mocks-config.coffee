# test: update-angular-mocks-config
# =================================
task   = 'update-angular-mocks-config'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe task, ->
	tests.run.task.sync task
	tests.run.spec "/config/#{task}"
