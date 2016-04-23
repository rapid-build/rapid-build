module.exports = (docsRoot) ->
	path    = require 'path'
	async   = require 'asyncawait/async'
	await   = require 'asyncawait/await'
	tasks   = path.join __dirname, 'tasks'
	helpers = path.join docsRoot, 'scripts', 'helpers'
	log     = require "#{helpers}/log"

	# tasks
	# =====
	decryptKey             = require "#{tasks}/decrypt-deploy-key"
	disableHostKeyChecking = require "#{tasks}/disable-host-key-checking"

	# run tasks
	# =========
	runTasks = async ->
		# res1 = ''
		res1 = await decryptKey docsRoot
		res2 = await disableHostKeyChecking docsRoot
		[res1, res2].filter(Boolean).join '\n'

	# run it!
	# =======
	runTasks()
