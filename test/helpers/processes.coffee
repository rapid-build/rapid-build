# processes helper
# ================
q  = require 'q'
ps = require 'ps-node'

# helpers
# =======
getPromise = (defer) ->
	defer.resolve()
	defer.promise

# API
# ===
api =
	collection: []

	add: (pid) ->
		return @ if typeof pid isnt 'number'
		@collection.push pid
		@

	get: ->
		@collection

	killOne: (pid) ->
		defer = q.defer()
		index = @collection.indexOf pid
		return getPromise defer if index is -1
		ps.kill pid, (e) =>
			@collection.splice index, 1
			# console.log "killed process: #{pid}".attn unless e
			defer.resolve()
		defer.promise

	kill: ->
		defer = q.defer()
		return getPromise defer unless @collection.length
		promises = []
		for pid in @collection
			do (pid) => promises.push => @killOne pid
		promises.reduce(q.when, q()).done -> defer.resolve()
		defer.promise

# export it!
# ==========
module.exports = api