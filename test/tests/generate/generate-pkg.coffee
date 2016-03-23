# test: generate-pkg
# ==================
task   = 'generate-pkg'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} task", ->
	tests.run.task.sync task
	tests.run.spec "/generate/#{task}"
