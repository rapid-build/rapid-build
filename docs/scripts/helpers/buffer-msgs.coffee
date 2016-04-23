module.exports =
	get: (e, stdout, stderr) ->
		msgs = e: '', stds: ''
		if e and typeof e.message is 'string'
			msgs.e = @getE e, false
		else
			stdout = @getStd stdout, 'stdout'
			stderr = @getStd stderr, 'stderr'
			msgs.stds = "#{stdout}\n#{stderr}".trim()
		msgs

	getE: (e, doCheck = true) ->
		msg = 'Error'
		return "#{msg}: #{e.message}" unless doCheck
		return msg if not e or typeof e.message isnt 'string'
		"#{msg}: #{e.message}"


	getStd: (std, type) ->
		return '' unless std and typeof std is 'string'
		"#{type}: "+std.replace(/\\n/g, '').trim()