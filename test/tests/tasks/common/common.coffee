# common task test
# ================
async    = require 'asyncawait/async'
await    = require 'asyncawait/await'
rb       = global.rb
fs       = rb.nm.fs
execSync = rb.nm.execSync
appPath  = rb.paths.abs.test.app
genPath  = rb.paths.abs.generated.testApp
prefix   = rb.pkgs.rb.tasksPrefix
genDir   = rb.pkgs.test.name

# tests
# =====
describe 'common task', ->
	it 'should run', async (done) ->
		try execSync "gulp #{prefix}common --silent", cwd: appPath
		catch e then e = e.message.replace /\r?\n|\r/g, ''
		# console.log 'COMMON'.info.bold
		expect(e).not.toBeDefined()
		done()

	describe 'clean-dist', ->
		it 'should delete dist dir', async (done) ->
			try stats = await fs.statAsync "#{appPath}/dist"
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