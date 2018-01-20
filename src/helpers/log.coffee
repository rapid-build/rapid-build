module.exports =
	json: (v, prefix) ->
		if prefix
			console.log prefix, JSON.stringify v, null, '\t'
		else
			console.log JSON.stringify v, null, '\t'

	task: (msg, type='attn') -> # see /src/bootstrap.coffee for types
		return unless msg
		console.log msg[type]

	error: (e, msg='') ->
		eMsg = e if typeof e is 'string'
		eMsg = e.message if e and e.message
		msg  = if msg and eMsg then "#{msg}\n#{eMsg}" else eMsg
		msg  = " #{msg}" if msg
		return unless msg
		console.error "ERROR:#{msg}".error

	watch: (taskName, file, opts={}) ->
		taskName = opts.logTaskName or taskName
		@task "#{taskName} #{file.event}: #{file.path}", 'minor'

	watchTS: (paths) ->
		@task "typescript changed: #{_path}", 'minor' for _path in paths
