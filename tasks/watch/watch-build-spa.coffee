# for watch events: add and unlink
# ================================
module.exports = (config, gulp, taskOpts={}) ->
	gulpSequence = require('gulp-sequence').use gulp

	# API
	# ===
	api =
		runTask: (cb) ->
			gulpSequence(
				"#{config.rb.prefix.task}build-files"
				"#{config.rb.prefix.task}build-spa"
				cb
			)

	# return
	# ======
	api.runTask taskOpts.taskCB

