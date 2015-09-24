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

		# build
		# =====
		return promiseHelp.get() unless config.build.client

		# angular
		# =======
		config.angular.removeRbMocksModule()
		config.angular.updateHttpBackendStatus()

		# order
		# =====
		config.order.removeRbAngularMocks()

		# globs
		# =====
		config.glob.removeRbAngularMocks()

		# return
		# ======
		promiseHelp.get()