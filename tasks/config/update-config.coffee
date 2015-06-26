# Task is only called from the common task.
# =========================================
module.exports = (gulp, config) ->
	promiseHelp = require "#{config.req.helpers}/promise"

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}update-config", ->
		# env
		# ===
		config.env.set gulp # must be first

		# angular
		# =======
		config.angular.removeRbMocksModule() # conditionally

		# order
		# =====
		config.order.removeRbAngularMocks() # conditionally

		# globs
		# =====
		config.glob.removeRbAngularMocks() # conditionally

		# return
		# ======
		promiseHelp.get()