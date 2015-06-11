module.exports =
	json: (data, pretty=true) ->
		return JSON.stringify data, null, '\t' if pretty
		JSON.stringify data