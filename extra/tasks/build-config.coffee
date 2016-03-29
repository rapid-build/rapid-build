# BUILD: /extra/temp/config.json
# ==============================
module.exports = (config) ->
	path = require 'path'
	fse  = require 'fs-extra'

	# vars
	# ====
	configPath = path.join config.paths.abs.extra.temp, 'config.json'
	format     = spaces: '\t'
	msgPath    = "built: #{configPath}"

	# task
	# ====
	task = ->
		try
			fse.writeJsonSync configPath, config, format
			# console.log msgPath
		catch e
			msg = e.message.replace /\r?\n|\r/g, ''
			console.error "FAILED build-config: #{msg}"

	# return
	# ======
	task()