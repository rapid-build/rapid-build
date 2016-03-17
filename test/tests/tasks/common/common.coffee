# common task test
# ================
async    = require 'asyncawait/async'
await    = require 'asyncawait/await'
Promise  = require 'bluebird'
execSync = require('child_process').execSync
fs       = Promise.promisifyAll require 'fs'
config   = require "#{process.cwd()}/temp/config.json"

# vars
# ====
appPaths = config.paths.abs.test.app
genPath  = config.paths.abs.generated.testApp
prefix   = config.pkgs.rb.tasksPrefix
genDir   = config.pkgs.test.name

# tests
# =====
describe 'common task', ->
	it 'should run', async (done) ->
		try stdout = execSync "gulp #{prefix}common --silent", cwd: appPaths.path
		catch e then e = e.message.replace /\r?\n|\r/g, ''
		# console.log stdout.toString().info if stdout
		expect(e).not.toBeDefined()
		done()

	describe 'clean-dist', ->
		it 'should delete dist dir', async (done) ->
			try stats = await fs.statAsync appPaths.dist.path
			result = stats?.isDirectory()
			expect(result).not.toBeDefined()
			done()

	describe 'generate-pkg', ->
		it "should create #{genDir} dir in generated dir", async (done) ->
			try stats = await fs.statAsync "#{genPath}"
			result = stats?.isDirectory()
			expect(result).toBeDefined()
			done()

	describe 'build-config', ->
		it 'should create config.json', async (done) ->
			try stats = await fs.statAsync "#{genPath}/config.json"
			result = stats?.isFile()
			expect(result).toBeDefined()
			done()