# processes helper
# ================
q    = require 'q'
ps   = require 'ps-node'
exec = require('child_process').exec

# constants
# =========
IS_WIN = process.platform is 'win32'

# helpers
# =======
get =
	key: (pid={}) -> # task name
		key = Object.keys pid
		key[0]

	val: (pid) -> # pid number
		pid[@key pid]

	promise: (val) -> # empty promise
		q.fcall -> val

# API
# ===
api =
	# public
	# ======
	collection: [] # ex: [ 'start-server': 15123, 'browser-sync': 16123  ]

	add: (pid) ->
		return unless pid
		key = get.key pid
		return @ if typeof pid[key] isnt 'number'
		@collection.push pid
		@

	get: ->
		@collection

	kill: (config={}) ->
		return get.promise [] unless @collection.length
		defer    = q.defer()
		promises = []
		pids     = []
		for pid in @collection
			do (pid) => promises.push (pids) => @killOne pid, pids, config
		promises.reduce(q.when, q(pids)).done (pids) -> defer.resolve pids
		defer.promise

	killOne: (pid, pids=[], config={}) ->
		return get.promise pids unless @_hasProcess pid
		defer  = q.defer()
		pidKey = get.key pid
		pidVal = get.val pid
		action = if IS_WIN then '_killOneWin' else '_killOneUnix'

		@[action] pidVal
			.then =>
				@_removeProcess pid
				@_logKill pidKey, pidVal, config
				pids.push pid
			.catch (e) =>
				@_logError e
			.done ->
				defer.resolve pids

		defer.promise

	# private
	# =======
	_getProcessIndex: (pid) ->
		@collection.indexOf pid

	_hasProcess: (pid) ->
		index = @_getProcessIndex pid
		index isnt -1

	_killOneUnix: (pid) -> # pid = number
		defer = q.defer()
		ps.kill pid, (e) ->
			return defer.reject e if e
			defer.resolve()
		defer.promise

	_killOneWin: (pid) -> # pid = number
		# taskkill is a windows command
		# https://technet.microsoft.com/en-us/library/bb491009.aspx
		defer = q.defer()
		cmd   = "taskkill /pid #{pid} /t /f"
		exec cmd, (e) ->
			return defer.reject e if e
			defer.resolve()
		defer.promise

	_logError: (e) ->
		return @ unless e
		msg = e.message.replace /\r?\n|\r/g, ' '
		console.log msg.error
		@

	_logKill: (pidKey, pidVal, config) ->
		return @ unless config
		return @ unless config.test.verbose.processes
		msg = "killed #{pidKey} process: #{pidVal}"
		console.log msg.info
		@

	_removeProcess: (pid) ->
		index = @_getProcessIndex pid
		@collection.splice index, 1
		@

# export it!
# ==========
module.exports = api




