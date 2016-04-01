module.exports = (config) ->
	q            = require 'q'
	rbServerFile = config.dist.rb.server.scripts.filePath

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			require rbServerFile
			defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()