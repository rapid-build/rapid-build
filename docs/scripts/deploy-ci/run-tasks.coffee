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
	addDeployKey           = require "#{tasks}/add-deploy-key"
	disableHostKeyChecking = require "#{tasks}/disable-host-key-checking"
	setGitConfigUser       = require "#{tasks}/set-git-config-user"
	gitClone               = require "#{tasks}/git-clone"

	# run tasks
	# =========
	runTasks = async ->
		# res1 = ''
		# res2 = ''
		# res5 = ''
		res1 = await decryptKey docsRoot
		res2 = await addDeployKey docsRoot
		res3 = await disableHostKeyChecking docsRoot
		res4 = await setGitConfigUser docsRoot
		res5 = await gitClone docsRoot
		[res1, res2, res3, res4, res5].filter(Boolean).join '\n'

	# run it!
	# =======
	runTasks()
