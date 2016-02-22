# common task test
# ================
async    = require 'asyncawait/async'
await    = require 'asyncawait/await'
fs       = global.rb.nm.fs
execSync = global.rb.nm.execSync
prefix   = global.rb.pkgs.rb.tasksPrefix
appPath  = global.rb.paths.abs.test.app
genPath  = global.rb.paths.abs.generated.testApp

# tests
# =====
describe 'common task', ->
	execSync "gulp #{prefix}common", cwd: appPath

	describe 'clean-dist', ->
		it 'should delete the dist directory', async (done) ->
			try stats = await fs.statAsync "#{appPath}/dist"
			cleaned = !stats?.isDirectory()
			expect(cleaned).toBeTrue 'cleaned'
			done()

	describe 'build-config', ->
		it 'should create config.json', async (done) ->
			try stats = await fs.statAsync "#{genPath}/config.json"
			created = !!stats?.isFile()
			expect(created).toBeTrue 'created'
			done()