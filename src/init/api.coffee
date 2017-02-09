# THE BUILD'S AVAILABLE TASKS
# ===========================
module.exports = (gulp, config) ->
	q            = require 'q'
	gulpSequence = require('gulp-sequence').use gulp
	taskHelp     = require("#{config.req.helpers}/tasks") config, gulp
	defer        = build: q.defer(), tasks: q.defer()
	tp           = config.rb.prefix.task # task prefix

	# Default
	# =======
	gulp.task config.rb.tasks.default, ["#{tp}common"], (cb) ->
		gulpSequence(
			"#{tp}common-client"
			"#{tp}common-server"
			"#{tp}build-spa"
			"#{tp}start-server"
			"#{tp}open-browser"
			cb
		) -> defer.tasks.resolve()

	# Test Default: Client and Server
	# ===============================
	gulp.task config.rb.tasks['test'], ["#{tp}common"], (cb) ->
		gulpSequence(
			config.rb.tasks['test:client']
			config.rb.tasks['test:server']
			cb
		) -> defer.tasks.resolve ["#{tp}stop-server"]

	# Test Default: Client
	# ====================
	gulp.task config.rb.tasks['test:client'], ["#{tp}common"], (cb) ->
		gulpSequence(
			"#{tp}common-client"
			"#{tp}build-spa"
			"#{tp}common-test-client"
			"#{tp}run-client-tests"
			cb
		) -> defer.tasks.resolve() unless taskHelp.wasCalledFrom config.rb.tasks['test']

	# Test Default: Server
	# ====================
	gulp.task config.rb.tasks['test:server'], ["#{tp}common"], (cb) ->
		gulpSequence(
			"#{tp}common-server"
			"#{tp}start-server"
			"#{tp}common-test-server"
			cb
		) ->
			return if taskHelp.wasCalledFrom config.rb.tasks['test']
			defer.tasks.resolve ["#{tp}stop-server"]

	# Dev
	# ===
	gulp.task config.rb.tasks.dev, ["#{tp}common"], (cb) ->
		gulpSequence(
			"#{tp}common-client"
			"#{tp}common-server"
			"#{tp}build-spa"
			"#{tp}start-server:dev"
			"#{tp}browser-sync"
			"#{tp}watch"
			cb
		) -> defer.tasks.resolve()

	# Test Dev: Client and Server
	# ===========================
	gulp.task config.rb.tasks['dev:test'], ["#{tp}common"], (cb) ->
		gulpSequence(
			"#{tp}common-client"
			"#{tp}build-spa"
			"#{tp}common-test-client"
			"#{tp}run-client-tests:dev"
			"#{tp}common-server"
			"#{tp}copy-server-tests"
			"#{tp}start-server:dev"
			"#{tp}browser-sync"
			"#{tp}run-server-tests:dev"
			"#{tp}watch"
			cb
		) -> defer.tasks.resolve()

	# Test Dev: Client
	# ================
	gulp.task config.rb.tasks['dev:test:client'], ["#{tp}common"], (cb) ->
		gulpSequence(
			"#{tp}common-client"
			"#{tp}build-spa"
			"#{tp}common-test-client"
			"#{tp}run-client-tests:dev"
			"#{tp}watch"
			cb
		) -> defer.tasks.resolve()

	# Test Dev: server
	# ================
	gulp.task config.rb.tasks['dev:test:server'], ["#{tp}common"], (cb) ->
		gulpSequence(
			"#{tp}common-server"
			"#{tp}copy-server-tests"
			"#{tp}start-server:dev"
			"#{tp}browser-sync"
			"#{tp}run-server-tests:dev"
			"#{tp}watch"
			cb
		) -> defer.tasks.resolve()

	# Prod
	# ====
	gulp.task config.rb.tasks.prod, ["#{tp}common"], (cb) ->
		gulpSequence(
			"#{tp}common-client"
			"#{tp}common-server"
			[
				"#{tp}minify-client"
				"#{tp}minify-server"
			]
			cb
		) -> defer.tasks.resolve() unless taskHelp.wasCalledFrom config.rb.tasks['prod:server']

	# Prod: Server
	# ============
	gulp.task config.rb.tasks['prod:server'], [config.rb.tasks.prod], (cb) ->
		gulpSequence(
			"#{tp}start-server"
			"#{tp}open-browser"
			cb
		) -> defer.tasks.resolve()

	# Test Prod: Client and Server
	# ============================
	gulp.task config.rb.tasks['prod:test'], ["#{tp}common"], (cb) ->
		gulpSequence(
			config.rb.tasks['prod:test:client']
			config.rb.tasks['prod:test:server']
			cb
		) -> defer.tasks.resolve ["#{tp}stop-server"]

	# Test Prod: Client
	# =================
	gulp.task config.rb.tasks['prod:test:client'], ["#{tp}common"], (cb) ->
		gulpSequence(
			"#{tp}common-client"
			"#{tp}minify-client"
			"#{tp}common-test-client"
			"#{tp}run-client-tests"
			"#{tp}clean-client-test-dist"
			cb
		) -> defer.tasks.resolve() unless taskHelp.wasCalledFrom config.rb.tasks['prod:test']

	# Test Prod: Server
	# =================
	gulp.task config.rb.tasks['prod:test:server'], ["#{tp}common"], (cb) ->
		gulpSequence(
			"#{tp}common-server"
			"#{tp}minify-server"
			"#{tp}start-server"
			"#{tp}common-test-server"
			"#{tp}clean-server-test-dist"
			cb
		) ->
			return if taskHelp.wasCalledFrom config.rb.tasks['prod:test']
			defer.tasks.resolve ["#{tp}stop-server"]

	# Common Build Event: On Tasks Complete
	# =====================================
	defer.tasks.promise.done (tasks=[]) ->
		gulpSequence(
			"#{tp}pack-dist"
			tasks...
		) -> defer.build.resolve config

	# return
	# ======
	defer.build.promise







