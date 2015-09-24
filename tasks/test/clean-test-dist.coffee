module.exports = (gulp, config) ->
	q           = require 'q'
	del         = require 'del'
	path        = require 'path'
	promiseHelp = require "#{config.req.helpers}/promise"

	cleanTask = (src) ->
		defer = q.defer()
		del(src, force:true).then (paths) ->
			# console.log 'cleaned dist test'.yellow
			defer.resolve()
		defer.promise

	runTask = ->
		src = [
			config.dist.rb.client.test.dir
			config.dist.app.client.test.dir
		]
		cleanTask src

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}clean-test-dist", ->
		return promiseHelp.get() unless config.build.client
		runTask()

