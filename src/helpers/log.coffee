# LOGGER
# for types see /src/bootstrap.coffee
# ===================================
module.exports =
	json: (v, prefix) -> # :void
		if prefix
			console.log prefix, JSON.stringify v, null, '\t'
		else
			console.log JSON.stringify v, null, '\t'

	task: (msg, type) -> # :void
		type = if typeof type is 'string' then type else 'attn'
		return unless msg
		return console.log msg[type] unless Array.isArray msg
		console.log _msg[type] for _msg in msg

	error: (e, msg='') -> # :void
		eMsg = e.error if typeof e is 'string'
		eMsg = e.message.red if e and e.message
		msg  = if msg and eMsg then "#{msg.error}\n#{eMsg}" else eMsg
		msg  = " #{msg}" if msg
		return unless msg
		prefix = 'ERROR:'.error
		console.error "#{prefix}#{msg}"

	taskError: (e, task={}) -> # :void (throws)
		eMsg = 'task'
		eMsg += " #{task.name}" if task.name
		@error e, eMsg

	watch: (taskName, file, opts={}) -> # :void
		taskName = opts.logTaskName or taskName
		@task "#{taskName} #{file.event}: #{file.path}", 'minor'

	watchTS: (paths) -> # :void
		@task "typescript changed: #{_path}", 'minor' for _path in paths
