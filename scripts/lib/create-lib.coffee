# CREATE LIB
# ==========
module.exports = ->
	q   = require 'q'
	lib = require '../utils/lib'
	src = require '../utils/src'

	# run tasks (in order, synchronously)
	# ===================================
	runTasks = ->
		# for local installs, MUST run before publishing!
		defer = q.defer()
		tasks = [
			-> src.installServer()
			-> lib.clean()
			-> lib.copySrc()
			-> lib.compileCoffee()
			-> lib.cleanCoffee()
			-> lib.cleanupServer()
			-> lib.minifyJs()
			-> lib.packServer()
			-> msg: 'lib created (success!)'
		]
		tasks.reduce(q.when, q()).done (msg) -> defer.resolve msg
		defer.promise

	# run it!
	# =======
	runTasks()

