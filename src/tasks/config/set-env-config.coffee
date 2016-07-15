# Task is only called from the common task.
# =========================================
module.exports = (config, gulp) ->
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

	# helpers
	# =======
	getMode = (mode) ->
		return unless mode
		mode.split(':').slice(1).join(':')

	# API
	# ===
	api =
		runTask: -> # mode = build mode
			return promiseHelp.get() if config.env.override # because it's already set
			mode = gulp.seq[2]
			mode = gulp.seq[3] if gulp.seq[3] is config.rb.tasks['prod:server'] # one off
			mode = getMode mode
			config.env.set mode
			log.task "running #{config.env.name} build"
			promiseHelp.get()

	# return
	# ======
	api.runTask()
