# test results: start-server:dev
# ==============================
task   = 'start-server:dev'
config = require "#{process.cwd()}/extra/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe "#{task} tasks", ->
	tests.test.results '/server/nodemon'