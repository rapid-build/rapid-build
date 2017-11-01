# UNPACK LIB SERVER
# =================
module.exports = ->
	q   = require 'q'
	lib = require '../utils/lib'

	# run tasks (in order, synchronously)
	# ===================================
	runTasks = ->
		# for consumer installs
		defer = q.defer()
		tasks = [
			-> lib.cleanServer()
			-> lib.unpackServer()
			-> msg: 'server unpacked (success!)'
		]
		tasks.reduce(q.when, q()).done (msg) -> defer.resolve msg
		defer.promise

	# run it!
	# =======
	runTasks()

