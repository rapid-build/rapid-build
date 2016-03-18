# test: common
# ============
task     = 'common'
execSync = require('child_process').execSync
config   = require "#{process.cwd()}/temp/config.json"
tests    = require("#{config.paths.abs.test.helpers}/tests") config
prefix   = config.pkgs.rb.tasksPrefix
appPath  = config.paths.abs.test.app.path

# tests
# =====
describe "#{task} task", ->
	it 'should run', (done) ->
		try stdout = execSync "gulp #{prefix}#{task} --silent", cwd: appPath
		catch e then e = tests.format.e e
		# console.log stdout.toString().info if stdout
		expect(e).not.toBeDefined()
		done()

	# run specs
	# =========
	tests.run.spec '/clean/clean-dist'
	tests.run.spec '/generate/generate-pkg'
	tests.run.spec '/build/build-config'
