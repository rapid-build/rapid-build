module.exports = (gulp, config) ->
	q    = require 'q'
	open = require 'open'

	runTask = (port) ->
		defer = q.defer()
		open "http://localhost:#{port}/", ->
			defer.resolve()
		defer.promise

	gulp.task "#{config.rb.prefix.task}open", ->
		runTask config.app.ports.server