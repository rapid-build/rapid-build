module.exports = (config) ->
	configHelp = require("#{config.req.helpers}/config") config

	# API
	# ===
	api =
		runTask: ->
			configHelp.buildFile true

	# return
	# ======
	api.runTask()