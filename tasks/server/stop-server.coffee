module.exports = (gulp, config) ->
	q              = require 'q'
	path           = require 'path'
	promiseHelp    = require "#{config.req.helpers}/promise"
	stopServerFile = path.join config.dist.rb.server.scripts.path, 'stop-server.js'

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}stop-server", ->
		return promiseHelp.get() unless config.build.server
		defer      = q.defer()
		stopServer = require stopServerFile
		stopServer().done -> defer.resolve()
		defer.promise