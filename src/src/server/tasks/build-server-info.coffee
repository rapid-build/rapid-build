module.exports = (server) ->
	path     = require 'path'
	fse      = require 'fs-extra'
	jsonFile = path.resolve __dirname, '..', 'server-info.json'
	json     =
		pid:  process.pid
		port: server.server.address().port

	fse.writeJSONSync jsonFile, json, spaces: '\t'