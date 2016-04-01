# test task: watch
# ================
task   = 'watch'
config = require "#{process.cwd()}/extra/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config
opts   = track: true

# tests
# =====
describe task, ->
	tests.test.task.async task, 'watching', opts
	tests.test.results "/watch/#{task}"
