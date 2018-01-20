# test task: build-spa
# ====================
task   = 'build-spa'
config = require "#{process.cwd()}/extra/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config
env    = if config.build.is.prod then 'prod' else 'dev'

# tests
# =====
describe task, ->
	tests.test.task.sync "#{task}:#{env}"
	tests.test.results "/build/#{task}"
