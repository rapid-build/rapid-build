# rapid-build's available tasks
# =============================
module.exports = (gulp, config) ->
	q            = require 'q'
	gulpSequence = require('gulp-sequence').use gulp
	defer        = q.defer()

	# rapid-build (default)
	# =====================
	gulp.task config.rb.tasks.default, ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}build-spa"
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}open-browser"
			cb
		) -> defer.resolve()

	# rapid-build:dev
	# ===============
	gulp.task config.rb.tasks.dev, ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}build-spa"
			"#{config.rb.prefix.task}start-server"
			"#{config.rb.prefix.task}browser-sync"
			"#{config.rb.prefix.task}watch"
			cb
		) -> defer.resolve()

	# rapid-build:test
	# ================
	gulp.task config.rb.tasks.test, ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			"#{config.rb.prefix.task}copy-tests"
			"#{config.rb.prefix.task}run-tests"
			cb
		) -> defer.resolve()

	# rapid-build:prod
	# ================
	gulp.task config.rb.tasks.prod, ["#{config.rb.prefix.task}common"], (cb) ->
		gulpSequence(
			[
				"#{config.rb.prefix.task}minify-client"
				"#{config.rb.prefix.task}minify-server"
			]
			"#{config.rb.prefix.task}start-server"
			cb
		) -> defer.resolve()

	# return
	# ======
	defer.promise


