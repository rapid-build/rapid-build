# RAPID-BUILD'S AVAILABLE TASKS
# =============================
module.exports = (gulp, config) ->
	q            = require 'q'
	gulpSequence = require('gulp-sequence').use gulp
	taskHelp     = require("#{config.req.helpers}/tasks") config, gulp
	defer        = q.defer()

	# default
	# =======
	gulp.task config.rb.tasks.default, ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-client"
			"#{config.rb.prefix.task}common-server"
			"#{config.rb.prefix.task}build-spa"
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}open-browser"
			cb
		) -> defer.resolve config

	# test default - client and server
	# ================================
	gulp.task config.rb.tasks['test'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			config.rb.tasks['test:client']
			config.rb.tasks['test:server']
			cb
		) -> defer.resolve config

	# test default - client
	# =====================
	gulp.task config.rb.tasks['test:client'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-client"
			"#{config.rb.prefix.task}build-spa"
			"#{config.rb.prefix.task}common-test-client"
			"#{config.rb.prefix.task}run-client-tests"
			cb
		) -> defer.resolve config unless taskHelp.wasCalledFrom config.rb.tasks['test']

	# test default - server
	# =====================
	gulp.task config.rb.tasks['test:server'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-server"
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}common-test-server"
			"#{config.rb.prefix.task}stop-server"
			cb
		) -> defer.resolve config unless taskHelp.wasCalledFrom config.rb.tasks['test']

	# dev
	# ===
	gulp.task config.rb.tasks.dev, ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-client"
			"#{config.rb.prefix.task}common-server"
			"#{config.rb.prefix.task}build-spa"
			"#{config.rb.prefix.task}start-server:dev"
			"#{config.rb.prefix.task}browser-sync"
			"#{config.rb.prefix.task}watch"
			cb
		) -> defer.resolve config

	# test dev - client and server
	# ============================
	gulp.task config.rb.tasks['dev:test'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-client"
			"#{config.rb.prefix.task}build-spa"
			"#{config.rb.prefix.task}common-test-client"
			"#{config.rb.prefix.task}run-client-tests:dev"
			"#{config.rb.prefix.task}common-server"
			"#{config.rb.prefix.task}copy-server-tests"
			"#{config.rb.prefix.task}start-server:dev"
			"#{config.rb.prefix.task}browser-sync"
			"#{config.rb.prefix.task}run-server-tests:dev"
			"#{config.rb.prefix.task}watch"
			cb
		) -> defer.resolve config

	# test dev - client
	# =================
	gulp.task config.rb.tasks['dev:test:client'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-client"
			"#{config.rb.prefix.task}build-spa"
			"#{config.rb.prefix.task}common-test-client"
			"#{config.rb.prefix.task}run-client-tests:dev"
			"#{config.rb.prefix.task}watch"
			cb
		) -> defer.resolve config

	# test dev - server
	# =================
	gulp.task config.rb.tasks['dev:test:server'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-server"
			"#{config.rb.prefix.task}copy-server-tests"
			"#{config.rb.prefix.task}start-server:dev"
			"#{config.rb.prefix.task}browser-sync"
			"#{config.rb.prefix.task}run-server-tests:dev"
			"#{config.rb.prefix.task}watch"
			cb
		) -> defer.resolve config

	# prod
	# ====
	gulp.task config.rb.tasks.prod, ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-client"
			"#{config.rb.prefix.task}common-server"
			[
				"#{config.rb.prefix.task}minify-client"
				"#{config.rb.prefix.task}minify-server"
			]
			cb
		) -> defer.resolve config unless taskHelp.wasCalledFrom config.rb.tasks['prod:server']

	# prod server
	# ===========
	gulp.task config.rb.tasks['prod:server'], [config.rb.tasks.prod], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}open-browser"
			cb
		) -> defer.resolve config

	# test prod - client and server
	# =============================
	gulp.task config.rb.tasks['prod:test'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			config.rb.tasks['prod:test:client']
			config.rb.tasks['prod:test:server']
			cb
		) -> defer.resolve config

	# test prod - client
	# ==================
	gulp.task config.rb.tasks['prod:test:client'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-client"
			"#{config.rb.prefix.task}minify-client"
			"#{config.rb.prefix.task}common-test-client"
			"#{config.rb.prefix.task}run-client-tests"
			"#{config.rb.prefix.task}clean-client-test-dist"
			cb
		) -> defer.resolve config unless taskHelp.wasCalledFrom config.rb.tasks['prod:test']

	# test prod - server
	# ==================
	gulp.task config.rb.tasks['prod:test:server'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-server"
			"#{config.rb.prefix.task}minify-server"
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}common-test-server"
			"#{config.rb.prefix.task}clean-server-test-dist"
			"#{config.rb.prefix.task}stop-server"
			cb
		) -> defer.resolve config unless taskHelp.wasCalledFrom config.rb.tasks['prod:test']

	# return
	# ======
	defer.promise







