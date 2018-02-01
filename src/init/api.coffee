# THE BUILD'S AVAILABLE TASKS
# ===========================
module.exports = (gulp, config) ->
	q     = require 'q'
	defer = build: q.defer(), tasks: q.defer()
	rb    = config.rb.prefix.task # task prefix

	# Default
	# =======
	gulp.task config.rb.tasks.default, gulp.series([
		(done) -> process.env.RB_MODE = config.rb.tasks.default; done()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}common-server"
		"#{rb}start-server"
		"#{rb}open-browser"
		(done) -> defer.tasks.resolve(); done()
	])

	# Test Default: Client
	# ====================
	gulp.task config.rb.tasks['test:client'], gulp.series([
		(done) -> process.env.RB_MODE = config.rb.tasks['test:client']; done()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}common-test-client"
		"#{rb}run-client-tests"
		(done) ->
			return done() if config.env.is.testBoth # called from test task, it will resolve()
			defer.tasks.resolve(); done()
	])

	# Test Default: Server
	# ====================
	gulp.task config.rb.tasks['test:server'], gulp.series([
		(done) -> process.env.RB_MODE = config.rb.tasks['test:server']; done()
		"#{rb}common"
		"#{rb}common-server"
		"#{rb}start-server"
		"#{rb}common-test-server"
		(done) ->
			return done() if config.env.is.testBoth # called from test task, it will resolve()
			defer.tasks.resolve(["#{rb}stop-server"]); done()
	])

	# Test Default: Both
	# ==================
	gulp.task config.rb.tasks.test, gulp.series([
		(done) -> process.env.RB_MODE = config.rb.tasks.test; done()
		"#{rb}common"
		config.rb.tasks['test:client']
		config.rb.tasks['test:server']
		(done) -> defer.tasks.resolve(["#{rb}stop-server"]); done()
	])

	# Dev
	# ===
	gulp.task config.rb.tasks.dev, gulp.series([
		(done) -> process.env.RB_MODE = config.rb.tasks.dev; done()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}common-server"
		"#{rb}start-server:dev"
		"#{rb}browser-sync"
		"#{rb}watch"
		(done) -> defer.tasks.resolve(); done()
	])

	# Test Dev: Client
	# ================
	gulp.task config.rb.tasks['dev:test:client'], gulp.series([
		(done) -> process.env.RB_MODE = config.rb.tasks['dev:test:client']; done()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}common-test-client"
		"#{rb}run-client-tests:dev"
		"#{rb}watch"
		(done) -> defer.tasks.resolve(); done()
	])

	# Test Dev: Server
	# ================
	gulp.task config.rb.tasks['dev:test:server'], gulp.series([
		(done) -> process.env.RB_MODE = config.rb.tasks['dev:test:server']; done()
		"#{rb}common"
		"#{rb}common-server"
		"#{rb}copy-server-tests"
		"#{rb}start-server:dev"
		"#{rb}browser-sync"
		"#{rb}run-server-tests:dev"
		"#{rb}watch"
		(done) -> defer.tasks.resolve(); done()
	])

	# Test Dev: Both
	# ==============
	gulp.task config.rb.tasks['dev:test'], gulp.series([
		(done) -> process.env.RB_MODE = config.rb.tasks['dev:test']; done()
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
		(done) -> defer.tasks.resolve(); done()
	])

	# Prod
	# ====
	gulp.task config.rb.tasks.prod, gulp.series([
		(done) ->
			process.env.RB_MODE = config.rb.tasks.prod unless process.env.RB_MODE
			done()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}common-server"
		gulp.parallel([
			"#{rb}minify-client"
			"#{rb}minify-server"
		])
		(done) ->
			return done() if config.env.is.prodServer
			defer.tasks.resolve(); done()
	])

	# Prod: Server
	# ============
	gulp.task config.rb.tasks['prod:server'], gulp.series([
		(done) -> process.env.RB_MODE = config.rb.tasks['prod:server']; done()
		config.rb.tasks.prod
		"#{rb}start-server"
		"#{rb}open-browser"
		(done) -> defer.tasks.resolve(); done()
	])

	# Test Prod: Client
	# =================
	gulp.task config.rb.tasks['prod:test:client'], gulp.series([
		(done) -> process.env.RB_MODE = config.rb.tasks['prod:test:client']; done()
		"#{rb}common"
		"#{rb}common-client"
		"#{rb}minify-client"
		"#{rb}common-test-client"
		"#{rb}run-client-tests"
		"#{rb}clean-client-test-dist"
		(done) ->
			return done() if config.env.is.testBoth # called from test task, it will resolve()
			defer.tasks.resolve(); done()
	])

	# Test Prod: Server
	# =================
	gulp.task config.rb.tasks['prod:test:server'], gulp.series([
		(done) -> process.env.RB_MODE = config.rb.tasks['prod:test:server']; done()
		"#{rb}common"
		"#{rb}common-server"
		"#{rb}minify-server"
		"#{rb}start-server"
		"#{rb}common-test-server"
		"#{rb}clean-server-test-dist"
		(done) ->
			return done() if config.env.is.testBoth # called from test task, it will resolve()
			defer.tasks.resolve(["#{rb}stop-server"]); done()
	])

	# Test Prod: Both
	# ===============
	gulp.task config.rb.tasks['prod:test'], gulp.series([
		(done) -> process.env.RB_MODE = config.rb.tasks['prod:test']; done()
		"#{rb}common"
		config.rb.tasks['prod:test:client']
		config.rb.tasks['prod:test:server']
		(done) -> defer.tasks.resolve(["#{rb}stop-server"]); done()
	])

	# When Tasks Complete
	# ===================
	defer.tasks.promise.done (tasks=[]) ->
		gulp.series([
			"#{rb}pack-dist"
			tasks...
			(done) -> defer.build.resolve(config); done()
		])()

	# Return Promise
	# ==============
	defer.build.promise