# Task is only called from the common task.
# =========================================
module.exports = (config, gulp, Task) ->
	q           = require 'q'
	promiseHelp = require "#{config.req.helpers}/promise"
	configHelp  = require("#{config.req.helpers}/config") config

	updateConfig = ->
		config.angular.removeRbMocksModule()
		config.angular.updateHttpBackendStatus()
		config.order.removeRbAngularMocks()
		config.glob.removeRbAngularMocks()
		promiseHelp.get()

	# API
	# ===
	api =
		runTask: -> # synchronously
			tasks = [
				-> updateConfig()
				-> configHelp.buildFile true, 'rebuild'
			]
			tasks.reduce(q.when, q()).then ->
				# log: 'minor'
				message: 'updated angular mocks config'

	# return
	# ======
	api.runTask()

