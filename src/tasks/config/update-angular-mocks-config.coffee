# Task is only called from the common task.
# =========================================
module.exports = (config) ->
	q           = require 'q'
	log         = require "#{config.req.helpers}/log"
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
			defer = q.defer()
			tasks = [
				-> updateConfig()
				-> configHelp.buildFile true, 'rebuild'
			]
			tasks.reduce(q.when, q()).done ->
				# log.task 'updated angular mocks config', 'info'
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()

