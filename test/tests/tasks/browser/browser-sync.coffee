# test task: browser-sync
# =======================
task   = 'browser-sync'
config = require "#{process.cwd()}/extra/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config
opts   = track: true

# tests
# =====
if process.env.RB_TEST_WATCH
	require "#{config.paths.abs.test.tests.tasks}/server/nodemon"

describe task, ->
	tests.test.task.async task, '[bs]', opts
	tests.test.results "/browser/#{task}"
