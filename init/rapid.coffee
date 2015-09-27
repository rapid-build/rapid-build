# RAPID-BUILD'S AVAILABLE TASKS
# =============================
module.exports = (gulp, config) ->
	q            = require 'q'
	gulpSequence = require('gulp-sequence').use gulp
	task         = require("#{config.req.helpers}/tasks") gulp
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
		) -> defer.resolve()

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
		) -> defer.resolve()

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
		) -> defer.resolve() unless task.wasCalledFrom config.rb.tasks['prod:server']

	# prod server
	# ===========
	gulp.task config.rb.tasks['prod:server'], [config.rb.tasks.prod], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}open-browser"
			cb
		) -> defer.resolve()

	# test client
	# ===========
	gulp.task config.rb.tasks['test:client'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-client"
			"#{config.rb.prefix.task}build-spa"
			"#{config.rb.prefix.task}common-test-client"
			cb
		) -> defer.resolve() unless task.wasCalledFrom config.rb.tasks['test']

	# Test client prod
	# ================
	gulp.task config.rb.tasks['test:client:prod'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-client"
			"#{config.rb.prefix.task}minify-client"
			"#{config.rb.prefix.task}common-test-client"
			"#{config.rb.prefix.task}clean-client-test-dist"
			cb
		) -> defer.resolve() unless task.wasCalledFrom config.rb.tasks['test:prod']


	# test server
	# ===========
	gulp.task config.rb.tasks['test:server'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-server"
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}common-test-server"
			cb
		) -> defer.resolve() unless task.wasCalledFrom config.rb.tasks['test']

	# test server prod
	# ================
	gulp.task config.rb.tasks['test:server:prod'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}common-server"
			"#{config.rb.prefix.task}minify-server"
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}common-test-server"
			"#{config.rb.prefix.task}clean-server-test-dist"
			cb
		) -> defer.resolve() unless task.wasCalledFrom config.rb.tasks['test:prod']

	# test client and server
	# ======================
	gulp.task config.rb.tasks['test'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			config.rb.tasks['test:client']
			config.rb.tasks['test:server']
			cb
		) -> defer.resolve()

	# test client and server
	# ======================
	gulp.task config.rb.tasks['test:prod'], ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			config.rb.tasks['test:client:prod']
			config.rb.tasks['test:server:prod']
			cb
		) -> defer.resolve()

	# return
	# ======
	defer.promise







