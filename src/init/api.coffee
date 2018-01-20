# THE BUILD'S AVAILABLE TASKS
# ===========================
module.exports = (gulp, config) ->
	q        = require 'q'
	taskHelp = require("#{config.req.helpers}/tasks") config, gulp
	defer    = build: q.defer(), tasks: q.defer()
	rb       = config.rb.prefix.task # task prefix

	# Default
	# =======
	gulp.task config.rb.tasks.default, gulp.series([
		(cb) -> process.env.RB_MODE = config.rb.tasks.default; cb()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}common-server"
		"#{rb}start-server"
		"#{rb}open-browser"
		(cb) -> defer.tasks.resolve(); cb()
	])

	# Test Default: Client
	# ====================
	gulp.task config.rb.tasks['test:client'], gulp.series([
		(cb) -> process.env.RB_MODE = config.rb.tasks['test:client']; cb()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}common-test-client"
		"#{rb}run-client-tests"
		(cb) ->
			return cb() if config.env.is.testBoth # called from test task, it will resolve()
			defer.tasks.resolve(); cb()
	])

	# Test Default: Server
	# ====================
	gulp.task config.rb.tasks['test:server'], gulp.series([
		(cb) -> process.env.RB_MODE = config.rb.tasks['test:server']; cb()
		"#{rb}common"
		"#{rb}common-server"
		"#{rb}start-server"
		"#{rb}common-test-server"
		(cb) ->
			return cb() if config.env.is.testBoth # called from test task, it will resolve()
			defer.tasks.resolve(["#{rb}stop-server"]); cb()
	])

	# Test Default: Both
	# ==================
	gulp.task config.rb.tasks.test, gulp.series([
		(cb) -> process.env.RB_MODE = config.rb.tasks.test; cb()
		"#{rb}common"
		config.rb.tasks['test:client']
		config.rb.tasks['test:server']
		(cb) -> defer.tasks.resolve(["#{rb}stop-server"]); cb()
	])

	# Dev
	# ===
	gulp.task config.rb.tasks.dev, gulp.series([
		(cb) -> process.env.RB_MODE = config.rb.tasks.dev; cb()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}common-server"
		"#{rb}start-server:dev"
		"#{rb}browser-sync"
		"#{rb}watch"
		(cb) -> defer.tasks.resolve(); cb()
	])

	# Test Dev: Client
	# ================
	gulp.task config.rb.tasks['dev:test:client'], gulp.series([
		(cb) -> process.env.RB_MODE = config.rb.tasks['dev:test:client']; cb()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}common-test-client"
		"#{rb}run-client-tests:dev"
		"#{rb}watch"
		(cb) -> defer.tasks.resolve(); cb()
	])

	# Test Dev: Server
	# ================
	gulp.task config.rb.tasks['dev:test:server'], gulp.series([
		(cb) -> process.env.RB_MODE = config.rb.tasks['dev:test:server']; cb()
		"#{rb}common"
		"#{rb}common-server"
		"#{rb}copy-server-tests"
		"#{rb}start-server:dev"
		"#{rb}browser-sync"
		"#{rb}run-server-tests:dev"
		"#{rb}watch"
		(cb) -> defer.tasks.resolve(); cb()
	])

	# Test Dev: Both
	# ==============
	gulp.task config.rb.tasks['dev:test'], gulp.series([
		(cb) -> process.env.RB_MODE = config.rb.tasks['dev:test']; cb()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}common-test-client"
		"#{rb}run-client-tests:dev"
		"#{rb}common-server"
		"#{rb}copy-server-tests"
		"#{rb}start-server:dev"
		"#{rb}browser-sync"
		"#{rb}run-server-tests:dev"
		"#{rb}watch"
		(cb) -> defer.tasks.resolve(); cb()
	])

	# Prod
	# ====
	gulp.task config.rb.tasks.prod, gulp.series([
		(cb) ->
			process.env.RB_MODE = config.rb.tasks.prod unless process.env.RB_MODE
			cb()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}common-server"
		gulp.parallel([
			"#{rb}minify-client"
			"#{rb}minify-server"
		])
		(cb) ->
			return cb() if config.env.is.prodServer
			defer.tasks.resolve(); cb()
	])

	# Prod: Server
	# ============
	gulp.task config.rb.tasks['prod:server'], gulp.series([
		(cb) -> process.env.RB_MODE = config.rb.tasks['prod:server']; cb()
		config.rb.tasks.prod
		"#{rb}start-server"
		"#{rb}open-browser"
		(cb) -> defer.tasks.resolve(); cb()
	])

	# Test Prod: Client
	# =================
	gulp.task config.rb.tasks['prod:test:client'], gulp.series([
		(cb) -> process.env.RB_MODE = config.rb.tasks['prod:test:client']; cb()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}minify-client"
		"#{rb}common-test-client"
		"#{rb}run-client-tests"
		"#{rb}clean-client-test-dist"
		(cb) ->
			return cb() if config.env.is.testBoth # called from test task, it will resolve()
			defer.tasks.resolve(); cb()
	])

	# Test Prod: Server
	# =================
	gulp.task config.rb.tasks['prod:test:server'], gulp.series([
		(cb) -> process.env.RB_MODE = config.rb.tasks['prod:test:server']; cb()
		"#{rb}common"
		"#{rb}common-server"
		"#{rb}minify-server"
		"#{rb}start-server"
		"#{rb}common-test-server"
		"#{rb}clean-server-test-dist"
		(cb) ->
			return cb() if config.env.is.testBoth # called from test task, it will resolve()
			defer.tasks.resolve(["#{rb}stop-server"]); cb()
	])

	# Test Prod: Both
	# ===============
	gulp.task config.rb.tasks['prod:test'], gulp.series([
		(cb) -> process.env.RB_MODE = config.rb.tasks['prod:test']; cb()
		"#{rb}common"
		config.rb.tasks['prod:test:client']
		config.rb.tasks['prod:test:server']
		(cb) -> defer.tasks.resolve(["#{rb}stop-server"]); cb()
	])

	# When Tasks Complete
	# ===================
	defer.tasks.promise.done (tasks=[]) ->
		gulp.series([
			"#{rb}pack-dist"
			tasks...
			(cb) -> defer.build.resolve(config); cb()
		])()

	# Return Promise
	# ==============
	defer.build.promise