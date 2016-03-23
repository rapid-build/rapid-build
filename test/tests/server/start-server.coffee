# test: start-server
# ==================
task   = 'start-server'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config
opts   = track: true

# tests
# =====
describe "#{task} task", ->
	tests.run.task.async task, 'server started', opts
	tests.run.spec "/server/#{task}"