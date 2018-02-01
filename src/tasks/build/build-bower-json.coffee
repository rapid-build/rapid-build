module.exports = (config, gulp, Task) ->
	fse = require 'fs-extra'

	# helpers
	# =======
	getData = ->
		version      = config.rb.version
		name         = config.rb.name
		dependencies = config.angular.bowerDeps
		{ name, version, dependencies }

	# API
	# ===
	api =
		runTask: (src, dest, file) ->
			format   = spaces: '\t'
			json     = getData()
			jsonFile = config.bower.rb.path
			fse.writeJson(jsonFile, json, format).then ->
				# log: 'minor'
				message: 'built bower.json'

	# return
	# ======
	api.runTask()