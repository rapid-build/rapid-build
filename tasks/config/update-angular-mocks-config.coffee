# Task is only called from the common task.
# =========================================
module.exports = (gulp, config) ->
	q           = require 'q'
	promiseHelp = require "#{config.req.helpers}/promise"
	configHelp  = require("#{config.req.helpers}/config") config

	updateConfig = ->
		config.angular.removeRbMocksModule()
		config.angular.updateHttpBackendStatus()
		config.order.removeRbAngularMocks()
		config.glob.removeRbAngularMocks()
		promiseHelp.get()

	runTasks = -> # synchronously
		defer = q.defer()
		tasks = [
			-> updateConfig()
			-> configHelp.buildFile true, 'rebuild'
		]
		tasks.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}update-angular-mocks-config", ->
		runTasks()

