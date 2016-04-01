# test task: nodemon
# ==================
task   = 'nodemon'
config = require "#{process.cwd()}/extra/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config
opts   = track: true

# tests
# =====
describe task, ->
	tests.test.task.async task, 'server started', opts
	tests.test.results "/server/#{task}"
