# test: start-server
# ==================
task   = 'start-server'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} task", ->
	tests.run.task.async task, 'server started'
	tests.run.spec "/server/#{task}"