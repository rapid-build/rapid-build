module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() unless config.build.client
	return promiseHelp.get() if config.exclude.angular.files

	# requires
	# ========
	del = require 'del'

	# API
	# ===
	api =
		runTask: ->
			src = [
				config.dist.rb.client.test.dir
				config.dist.app.client.test.dir
			]
			del(src, force:true).then (paths) ->
				# log: 'minor'
				message: 'cleaned client dist test'

	# return
	# ======
	api.runTask()
