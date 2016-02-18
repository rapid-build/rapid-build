async    = require 'asyncawait/async'
await    = require 'asyncawait/await'
path     = require 'path'
Promise  = require 'bluebird'
execSync = require('child_process').execSync
fs       = Promise.promisifyAll require 'fs'
rootDir  = process.cwd()
appPath  = path.join rootDir, 'test', 'app'
genPath  = path.join rootDir, 'generated', 'build-test'


describe 'common task', ->
	execSync 'gulp rb-common', cwd: appPath

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