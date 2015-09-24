module.exports = (gulp, config) ->
	q           = require 'q'
	open        = require 'open'
	promiseHelp = require "#{config.req.helpers}/promise"

	runTask = (port) ->
		defer = q.defer()
		open "http://localhost:#{port}/", ->
			defer.resolve()
		defer.promise

	gulp.task "#{config.rb.prefix.task}open-browser", ->
		return promiseHelp.get() unless config.build.server
		runTask config.ports.server