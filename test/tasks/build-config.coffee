# build /temp/config.json for spec files
# ======================================
module.exports = (config, msg='built') ->
	# requires
	# ========
	Promise = require 'bluebird'
	fse     = Promise.promisifyAll require 'fs-extra'

	# vars
	# ====
	file       = 'config.json'
	configPath = "#{config.paths.abs.temp}/#{file}"
	msg        = 'rebuilt' if msg isnt 'built'
	msgPath    = "#{msg}: /temp/#{file}"
	format     = spaces: '\t'

	# return task
	# ===========
	fse.writeJsonAsync configPath, config, format
		# .then -> console.log msgPath.info
		.catch (e) -> console.log "build-config failed: #{e.message}".error
