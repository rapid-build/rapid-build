# test: es6:server
# ================
task   = "es6:server"
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe task, ->
	tests.run.task.sync task
	tests.run.spec "/compile/#{task}"
