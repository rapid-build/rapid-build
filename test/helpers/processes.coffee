# processes helper
# ================
q  = require 'q'
ps = require 'ps-node'

# helpers
# =======
getKey = (pid={}) -> # task name
	key = Object.keys pid
	key[0]

getPromise = (defer) ->
	defer.resolve()
	defer.promise

# API
# ===
api =
	collection: []

	add: (pid) ->
		return unless pid
		key = getKey pid
		return @ if typeof pid[key] isnt 'number'
		@collection.push pid
		@

	get: ->
		@collection

	killOne: (pid, config, pids=[]) ->
		defer = q.defer()
		index = @collection.indexOf pid
		return getPromise defer if index is -1
		key   = getKey pid
		ps.kill pid[key], (e) =>
			@collection.splice index, 1
			if not e and config and config.test.verbose.processes
				console.log "killed #{key} process: #{pid[key]}".info
			pids.push pid
			defer.resolve pids
		defer.promise

	kill: (config) ->
		defer = q.defer()
		return getPromise defer unless @collection.length
		promises = []
		for pid in @collection
			do (pid) => promises.push (pids) => @killOne pid, config, pids
		promises.reduce(q.when, q([])).done (pids) -> defer.resolve pids
		defer.promise

# export it!
# ==========
module.exports = api




