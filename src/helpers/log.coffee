module.exports =
	json: (v, prefix) ->
		if prefix
			console.log prefix, JSON.stringify v, null, '\t'
		else
			console.log JSON.stringify v, null, '\t'

	task: (msg, type='attn') -> # see /src/bootstrap.coffee for types
		return unless msg
		console.log msg[type]

	watch: (taskName, file, opts={}) ->
		taskName = opts.logTaskName or taskName
		@task "#{taskName} #{file.event}: #{file.path}", 'minor'

	watchTS: (paths) ->
		@task "typescript changed: #{_path}", 'minor' for _path in paths
