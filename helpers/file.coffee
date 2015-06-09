module.exports = ->
	fs = require 'fs'

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
			if pretty
				data = JSON.stringify data, null, '\t'
			else
				data = JSON.stringify data
			fs.writeFileSync _path, data



