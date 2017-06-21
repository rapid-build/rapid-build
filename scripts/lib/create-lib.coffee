# CREATE LIB
# ==========
module.exports = ->
	async = require 'asyncawait/async'
	await = require 'asyncawait/await'
	lib   = require '../utils/lib'
	src   = require '../utils/src'

	# run tasks (in order, synchronously)
	# ===================================
	runTasks = async ->
		# for local installs, MUST run before publishing!
		await src.installServer()
		await lib.clean()
		await lib.copySrc()
		await lib.compileCoffee()
		await lib.cleanCoffee()
		await lib.cleanupServer()
		await lib.minifyJs()
		await lib.packServer()
		msg: 'lib created (success!)'

	# run it!
	# =======
	runTasks()

