# test results: set-env-config
# ============================
task             = 'set-env-config'
config           = require "#{process.cwd()}/extra/temp/config.json"
tests            = require("#{config.paths.abs.test.helpers}/tests") config
modeMsg          = 'process.env.RB_MODE_OVERRIDE'
RB_MODE_OVERRIDE = process.env.RB_MODE_OVERRIDE
BUILD_MODE       = RB_MODE_OVERRIDE or 'default'

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
				expect(env.override).toBeTrue() if !!RB_MODE_OVERRIDE

			it "should be false if #{modeMsg} isnt set", ->
				expect(env.override).toBeFalse() unless RB_MODE_OVERRIDE
