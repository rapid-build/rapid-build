module.exports = (config) ->
	q           = require 'q'
	del         = require 'del'
	promiseHelp = require "#{config.req.helpers}/promise"

	cleanTask = (src) ->
		defer = q.defer()
		del(src, force:true).then (paths) ->
			# console.log 'cleaned server dist test'.yellow
			defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() unless config.build.server
			src = [
				config.dist.rb.server.test.dir
				config.dist.app.server.test.dir
				config.node_modules.rb.dist.modules['jasmine-expect']
			]
			cleanTask src

	# return
	# ======
	api.runTask()

