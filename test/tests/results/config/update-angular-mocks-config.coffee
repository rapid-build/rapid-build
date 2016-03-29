# test results: update-angular-mocks-config
# =========================================
task   = 'update-angular-mocks-config'
config = require "#{process.cwd()}/temp/config.json"
tests  = require("#{config.paths.abs.test.helpers}/tests") config

# tests
# =====
describe task, ->
	describe 'angular properties', ->
		angular = undefined

		beforeAll ->
			angular = tests.get.app.config().angular

		describe 'modules', ->
			it 'should remove ngMockE2E if env is prod and angular.httpBackend.prod is false', ->
				if config.build.is.prod and not angular.httpBackend.prod
					expect(angular.modules).not.toContain 'ngMockE2E'
