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
			prodServer    = config.rb.tasks['prod:server']
			testProd      = config.rb.tasks['test:prod']
			calledFromApi = gulp.seq.indexOf(prodServer) isnt -1
			calledFromApi = gulp.seq.indexOf(testProd) isnt -1 unless calledFromApi
			# console.log "call from api: #{calledFromApi}".cyan
			defer.resolve() unless calledFromApi

	# PROD SERVER: rapid-build:prod:server
	# ====================================
	gulp.task config.rb.tasks['prod:server'], [config.rb.tasks.prod], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}open-browser"
			cb
		) -> defer.resolve()

	# TEST: rapid-build:test
	# ======================
	gulp.task config.rb.tasks.test, ["#{config.rb.prefix.task}common"], (cb) ->
		return defer.resolve() if config.exclude.angular.files
		gulpSequence(
			"#{config.rb.prefix.task}common-test"
			cb
		) -> defer.resolve()

	# TEST PROD: rapid-build:test:prod
	# ================================
	gulp.task config.rb.tasks['test:prod'], [config.rb.tasks.prod], (cb) ->
		return defer.resolve() if config.exclude.angular.files
		gulpSequence(
			"#{config.rb.prefix.task}common-test"
			"#{config.rb.prefix.task}clean-test-dist"
			cb
		) -> defer.resolve()

	# return
	# ======
	defer.promise




