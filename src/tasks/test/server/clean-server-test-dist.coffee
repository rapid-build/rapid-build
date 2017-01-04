module.exports = (config) ->
	q           = require 'q'
	del         = require 'del'
	log         = require "#{config.req.helpers}/log"
	promiseHelp = require "#{config.req.helpers}/promise"

	cleanTask = (src) ->
		defer = q.defer()
		del(src, force:true).then (paths) ->
			log.task "cleaned test files in: #{config.dist.app.server.dir}"
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
			]
			cleanTask src

	# return
	# ======
	api.runTask()

