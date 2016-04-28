module.exports = (docsRoot) ->
	path  = require 'path'
	async = require 'asyncawait/async'
	await = require 'asyncawait/await'
	tasks = path.join __dirname, 'tasks'

	# tasks
	# =====
	cleanDist  = require "#{tasks}/clean-dist"
	unpackDist = require "#{tasks}/unpack-dist"
	cleanHost  = require "#{tasks}/clean-host"

	# run tasks
	# =========
	runTasks = async ->
		res1 = await cleanDist docsRoot
		res2 = await unpackDist docsRoot
		res3 = await cleanHost docsRoot
		res  = [res1, res2, res3]
		res.filter(Boolean).join '\n'

	# run it!
	# =======
	runTasks()



