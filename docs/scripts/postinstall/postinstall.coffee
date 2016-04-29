module.exports = (docsRoot) ->
	path  = require 'path'
	async = require 'asyncawait/async'
	await = require 'asyncawait/await'
	tasks = path.join __dirname, 'tasks'
	res   = []

	# tasks
	# =====
	cleanDist  = require "#{tasks}/clean-dist"
	unpackDist = require "#{tasks}/unpack-dist"
	cleanHost  = require "#{tasks}/clean-host"

	# run tasks
	# =========
	runTasks = async ->
		res.push await cleanDist docsRoot
		res.push await unpackDist docsRoot
		res.push await cleanHost docsRoot
		res.filter(Boolean).join '\n'

	# run it!
	# =======
	runTasks()



