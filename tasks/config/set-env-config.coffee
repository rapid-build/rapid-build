# Task is only called from the common task.
# =========================================
module.exports = (config, gulp) ->
	promiseHelp = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: ->
			config.env.set gulp.seq
			promiseHelp.get()

	# return
	# ======
	api.runTask()
