module.exports =
	json: (v, prefix) ->
		if prefix
			console.log prefix, JSON.stringify v, null, '\t'
		else
			console.log JSON.stringify v, null, '\t'

	watch: (taskName, file) ->
		console.log "#{taskName} #{file.event}: #{file.path}".yellow