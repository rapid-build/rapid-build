# test results: set-env-config
# ============================
task        = 'set-env-config'
config      = require "#{process.cwd()}/temp/config.json"
tests       = require("#{config.paths.abs.test.helpers}/tests") config
modeMsg     = 'process.env.RB_MODE'
ENV_RB_MODE = process.env.RB_MODE
BUILD_MODE  = ENV_RB_MODE or 'default'

# tests
# =====
describe task, ->
	describe 'env properties', ->
		env = undefined

		beforeAll ->
			env = tests.get.app.config().env

		describe 'name', ->
			it "should be equal to #{BUILD_MODE}", ->
				expect(env.name).toEqual BUILD_MODE

		describe 'override', ->
			it "should be true if #{modeMsg} is set", ->
				expect(env.override).toBeTrue() if !!ENV_RB_MODE

			it "should be false if #{modeMsg} isnt set", ->
				expect(env.override).toBeFalse() unless ENV_RB_MODE
