module.exports = (gulp, config) ->
	gulpSequence = require('gulp-sequence').use gulp
	promiseHelp  = require "#{config.req.helpers}/promise"

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}start-server", (cb) ->
		return promiseHelp.get() unless config.build.server
		gulpSequence(
			"#{config.rb.prefix.task}spawn-server"
			cb
		)

	gulp.task "#{config.rb.prefix.task}start-server:dev", (cb) ->
		return promiseHelp.get() unless config.build.server
		gulpSequence(
			"#{config.rb.prefix.task}nodemon"
			cb
		)

