# tests helper
# ============
module.exports = (config) ->
	path       = require 'path'
	spawn      = require('child_process').spawn
	execSync   = require('child_process').execSync
	moduleHelp = require "#{config.paths.abs.test.helpers}/module"
	processes  = require "#{config.paths.abs.test.helpers}/processes"

	# constants
	# =========
	IS_WIN          = process.platform is 'win32'
	FILE_EXT        = path.extname __filename
	BUILD_PATH      = config.paths.abs.root
	TEST_REL        = config.paths.rel.test.path
	TESTS_ABS       = config.paths.abs.test.tests
	TESTS_REL       = config.paths.rel.test.tests
	PREFIX          = config.pkgs.rb.tasksPrefix
	TASK_OPTS       = cwd: config.paths.abs.test.app.path
	APP_CONFIG_PATH = "#{config.paths.abs.generated.testApp}/config.json"
	TEST_TIMEOUT    = 10000 # jasmine default is 5 seconds

	# api
	# ===
	api =
		get:
			test: (test) -> # test = relative to test/test/
				test = path.join TESTS_REL['path'], test
				test

			tests: (tests, kind) -> # kind = results | tasks
				relPath = TESTS_REL[kind]
				tests   = (path.join relPath, "#{item}.*" for item in tests)
				tests

			log:
				path: (test) ->
					test = test.replace TEST_REL, ''
					test

			app:
				config: ->
					appConfig = path.normalize APP_CONFIG_PATH # for windows
					moduleHelp.cache.delete appConfig
					require APP_CONFIG_PATH

		format:
			e: (e) ->
				e.message.replace /\r?\n|\r/g, ''

		test:
			results: (test) ->
				test = test.replace /:/g, '-' if test.indexOf(':') isnt -1
				test = "#{test}#{FILE_EXT}"
				test = path.join TESTS_ABS['results'], test
				test = path.normalize test   # for windows
				moduleHelp.cache.delete test # for jasmine watch
				require test

			task:
				async: (task, needle, opts={}) -> # asynchronously
					it 'should run', (done) ->
						return done.fail 'manually' if opts.fail
						args = ["#{PREFIX}#{task}"]
						args.push '--silent' unless opts.verbose

						cmd   = if IS_WIN then 'gulp.cmd' else 'gulp'
						child = spawn cmd, args, TASK_OPTS
						processes.add "#{task}": child.pid if opts.track

						child.stdout.on 'data', (data) ->
							return unless data
							data = data.toString()
							console.log data.info if config.test.verbose.tasks
							return if data.toLowerCase().indexOf(needle) is -1
							done()

						child.on 'error', (e) -> # test error
							return unless e
							done.fail e.message

						return if IS_WIN

						child.on 'exit', (code) -> # task error
							return unless code is 1
							done.fail 'task exit code should not be 1'
					, TEST_TIMEOUT


				sync: (task, opts={}) -> # synchronously
					it 'should run', (done) ->
						return done.fail 'manually' if opts.fail
						silent = if opts.verbose then '' else '--silent'
						task   = "gulp #{PREFIX}#{task} #{silent}"
						try stdout = execSync task, TASK_OPTS
						catch e then e = api.format.e e
						console.log stdout.toString().info if config.test.verbose.tasks
						expect(e).not.toBeDefined()
						done()
					, TEST_TIMEOUT









