# test task: open-browser
# =======================
task   = 'open-browser'
config = require "#{process.cwd()}/extra/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config
opts   = track: true, verbose: true

# tests
# =====
describe task, ->
	tests.test.task.async task, 'open-browser', opts
	tests.test.results "/browser/#{task}" # todo