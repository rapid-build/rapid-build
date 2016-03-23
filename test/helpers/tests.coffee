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
	FILE_EXT        = path.extname __filename
	BUILD_PATH      = config.paths.abs.root
	BUILDS_PATH     = config.paths.abs.test.builds
	TESTS_PATH      = config.paths.abs.test.tests
	PREFIX          = config.pkgs.rb.tasksPrefix
	TASK_OPTS       = cwd: config.paths.abs.test.app.path
	APP_CONFIG_PATH = "#{config.paths.abs.generated.testApp}/config.json"

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

			app:
				config: ->
					require APP_CONFIG_PATH

		format:
			e: (e) ->
				e.message.replace /\r?\n|\r/g, ''

		run:
			spec: (spec) ->
				spec = spec.replace /:/g, '-'
				spec = "#{TESTS_PATH}#{spec}-spec#{FILE_EXT}"
				spec = path.normalize spec   # for windows
				moduleHelp.cache.delete spec # for jasmine watch
				require spec

			task:
				async: (task, needle, opts={}) -> # asynchronously
					it 'should run', (done) ->
						return done.fail 'manually' if opts.fail
						task  = "#{PREFIX}#{task}"
						child = spawn 'gulp', [task, '--silent'], TASK_OPTS
						processes.add child.pid

						child.stdout.on 'data', (data) ->
							return unless data
							data = data.toString()
							# console.log 'STDOUT'.attn
							console.log data.info if config.test.verbose.tasks
							return if data.toLowerCase().indexOf(needle) is -1
							done()

						child.on 'error', (e) -> # test error
							return unless e
							# console.log 'TEST ERROR'.error
							done.fail e.message

						child.on 'exit', (code) -> # task error
							return unless code is 1
							# console.log 'TASK EXIT'.error
							done.fail 'task exit code should not be 1'


				sync: (task, opts={}) -> # synchronously
					it 'should run', (done) ->
						return done.fail 'manually' if opts.fail
						task = "gulp #{PREFIX}#{task} --silent"
						try stdout = execSync task, TASK_OPTS
						catch e then e = api.format.e e
						console.log stdout.toString().info if config.test.verbose.tasks
						expect(e).not.toBeDefined()
						done()









