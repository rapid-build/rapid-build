# test: open-browser
# ==================
task   = 'open-browser'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config
opts   = track: true, verbose: true

# tests
# =====
describe "#{task} task", ->
	tests.run.task.async task, 'open-browser', opts
	tests.run.spec "/browser/#{task}" # todo