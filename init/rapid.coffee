# rapid-build's available tasks
# =============================
module.exports = (gulp, config) ->
	q            = require 'q'
	gulpSequence = require('gulp-sequence').use gulp
	defer        = q.defer()

	# DEFAULT: rapid-build
	# ====================
	gulp.task config.rb.tasks.default, ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}build-spa"
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}open-browser"
			cb
		) -> defer.resolve()

	# DEV: rapid-build:dev
	# ====================
	gulp.task config.rb.tasks.dev, ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}build-spa"
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}browser-sync"
			"#{config.rb.prefix.task}watch"
			cb
		) -> defer.resolve()

	# TEST: rapid-build:test
	# ======================
	gulp.task config.rb.tasks.test, ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}copy-tests"
			"#{config.rb.prefix.task}build-test-files"
			"#{config.rb.prefix.task}run-tests"
			cb
		) -> defer.resolve()

	# PROD: rapid-build:prod
	# ======================
	gulp.task config.rb.tasks.prod, ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			[
				"#{config.rb.prefix.task}minify-client"
				"#{config.rb.prefix.task}minify-server"
			]
			cb
		) ->
			prodServer           = config.rb.tasks['prod:server']
			calledFromProdServer = gulp.seq.indexOf(prodServer) isnt -1
			defer.resolve() unless calledFromProdServer

	# PROD SERVER: rapid-build:prod:server
	# ====================================
	gulp.task config.rb.tasks['prod:server'], [config.rb.tasks.prod], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}open-browser"
			cb
		) -> defer.resolve()

	# return
	# ======
	defer.promise


