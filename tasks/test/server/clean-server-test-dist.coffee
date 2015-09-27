module.exports = (gulp, config) ->
	q           = require 'q'
	del         = require 'del'
	promiseHelp = require "#{config.req.helpers}/promise"

	cleanTask = (src) ->
		defer = q.defer()
		del(src, force:true).then (paths) ->
			# console.log 'cleaned server dist test'.yellow
			defer.resolve()
		defer.promise

	runTask = ->
		src = [
			config.dist.rb.server.test.dir
			config.dist.app.server.test.dir
		]
		cleanTask src

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}clean-server-test-dist", ->
		return promiseHelp.get() unless config.build.server
		runTask()

