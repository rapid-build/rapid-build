# UNPACK LIB SERVER
# =================
module.exports = ->
	async = require 'asyncawait/async'
	await = require 'asyncawait/await'
	lib   = require '../utils/lib'

	# run tasks (in order, synchronously)
	# ===================================
	runTasks = async ->
		# for consumer installs
		await lib.cleanServer()
		await lib.unpackServer()
		msg: 'server unpacked (success!)'

	# run it!
	# =======
	runTasks()

