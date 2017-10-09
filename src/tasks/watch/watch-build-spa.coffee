# for watch events: add and unlink
# ================================
module.exports = (config, gulp, taskOpts={}) ->
	# API
	# ===
	api =
		runTask: ->
			gulp.series([
				"#{config.rb.prefix.task}build-files"
				"#{config.rb.prefix.task}build-spa"
				(cb) -> cb(); taskOpts.taskCB()
			])()

	# return
	# ======
	api.runTask()

