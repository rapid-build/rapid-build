module.exports = (config) ->
	fs     = require 'fs'
	format = require "#{config.req.helpers}/format"

	exists: (_path) ->
		try
			fs.lstatSync(_path).isFile()
		catch e
			false

	read:
		json: (_path) ->
			data = fs.readFileSync(_path).toString()
			JSON.parse data

	write:
		json: (_path, data, pretty=true) ->
			data = format.json data
			fs.writeFileSync _path, data



