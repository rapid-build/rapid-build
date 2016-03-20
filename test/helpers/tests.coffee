# tests helper
# ============
module.exports = (config) ->
	path       = require 'path'
	execSync   = require('child_process').execSync
	moduleHelp = require "#{config.paths.abs.test.helpers}/module"

	# constants
	# =========
	FILE_EXT    = path.extname __filename
	BUILD_PATH  = config.paths.abs.root
	BUILDS_PATH = config.paths.abs.test.builds
	TESTS_PATH  = config.paths.abs.test.tests
	PREFIX      = config.pkgs.rb.tasksPrefix
	TASK_OPTS   = cwd: config.paths.abs.test.app.path

	# api
	# ===
	api =
		get:
			path: (test, loc) -> # loc = abs | rel
				rootPath = BUILD_PATH
				test     = test.replace(rootPath, '').substring 1
				test

			paths: (build, loc) -> # loc = abs | rel
				loc   = config.paths[loc].test.tests
				build = 'default' unless build
				tests = require("#{BUILDS_PATH}/api")[build]
				tests = (path.join loc, "#{item}.*" for item in tests)
				tests

			log:
				path: (test) ->
					test = test.replace 'test', ''
					test
		format:
			e: (e) ->
				e.message.replace /\r?\n|\r/g, ''

		run:
			spec: (spec) ->
				specFile = "#{TESTS_PATH}#{spec}-spec#{FILE_EXT}"
				specFile = path.normalize specFile # for windows
				moduleHelp.cache.delete specFile   # for jasmine watch
				require specFile

			task: (task, opts={}) -> # synchronously
				it 'should run', (done) ->
					return done.fail 'manually' if opts.fail
					task = "gulp #{PREFIX}#{task} --silent"
					try stdout = execSync task, TASK_OPTS
					catch e then e = api.format.e e
					console.log stdout.toString().info if opts.verbose
					expect(e).not.toBeDefined()
					done()









