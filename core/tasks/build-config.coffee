# build /temp/config.json
# =======================
module.exports = (config) ->
	require 'colors'
	path   = require 'path'
	fse    = require 'fs-extra'

	# vars
	# ====
	configPath = path.join config.paths.abs.temp, 'config.json'
	format     = spaces: '\t'
	msgPath    = "built: #{configPath}"

	# task
	# ====
	task = ->
		try
			fse.writeJsonSync configPath, config, format
			# console.log msgPath.cyan
		catch e
			msg = e.message.replace /\r?\n|\r/g, ''
			console.error "FAILED build-config: #{msg}".red.bold

	# return
	# ======
	task()