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
describe 'common-client task', ->
	it 'should run', async (done) ->
		try execSync "gulp #{prefix}common-client --silent", cwd: appPaths.path
		catch e then e = e.message.replace /\r?\n|\r/g, ''
		# console.log 'COMMON CLIENT'.info.bold
		expect(e).not.toBeDefined()
		done()

	describe 'build-bower-json', ->
		it 'should create bower.json', async (done) ->
			try stats = await fs.statAsync "#{genPath}/bower.json"
			result = stats?.isFile()
			expect(result).toBeDefined()
			done()

	describe 'copy-images', ->
		it 'should copy images to dist', async (done) ->
			try stats = await fs.statAsync "#{appPaths.dist.client.images}/superheroes/superheroes.png"
			result = stats?.isFile()
			expect(result).toBeDefined()
			done()

	describe 'copy-js:client', ->
		it 'should copy js to dist', async (done) ->
			try stats = await fs.statAsync "#{appPaths.dist.client.scripts}/values/superheroes.js"
			result = stats?.isFile()
			expect(result).toBeDefined()
			done()

	describe 'coffee:client', ->
		it 'should compile coffee scripts to dist', async (done) ->
			try stats = await fs.statAsync "#{appPaths.dist.client.scripts}/controllers/home-controller.js"
			result = stats?.isFile()
			expect(result).toBeDefined()
			done()

	describe 'es6:client', ->
		it 'should compile es6 scripts to dist', async (done) ->
			try stats = await fs.statAsync "#{appPaths.dist.client.scripts}/configs/router.js"
			result = stats?.isFile()
			expect(result).toBeDefined()
			done()