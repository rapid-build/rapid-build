module.exports = (docsRoot, deployer, deploy, tag=false) ->
	path  = require 'path'
	async = require 'asyncawait/async'
	await = require 'asyncawait/await'
	tasks = path.join __dirname, 'tasks'
	res   = []

	# tasks
	# =====
	decryptKey             = require "#{tasks}/decrypt-deploy-key"
	addDeployKey           = require "#{tasks}/add-deploy-key"
	disableHostKeyChecking = require "#{tasks}/disable-host-key-checking"
	setGitConfigUser       = require "#{tasks}/set-git-config-user"
	gitClone               = require "#{tasks}/git-clone"
	moveGitAndCleanTemp    = require "#{tasks}/move-git-and-clean-temp"
	buildProd              = require "#{tasks}/build-prod"
	packDist               = require "#{tasks}/pack-dist"
	gitCommitPushAndTag    = require "#{tasks}/git-commit-push-and-tag"
	deployDocs             = require "#{tasks}/deploy-docs"

	# run tasks
	# =========
	switch deployer
		when 'ci'
			runTasks = async ->
				res.push await decryptKey docsRoot
				res.push await addDeployKey docsRoot
				res.push await disableHostKeyChecking docsRoot
				res.push await setGitConfigUser docsRoot
				res.push await gitClone docsRoot
				res.push await moveGitAndCleanTemp docsRoot
				res.push await buildProd docsRoot
				res.push await packDist docsRoot
				res.push await gitCommitPushAndTag docsRoot, deploy, true
				res.push await deployDocs docsRoot, deploy
				res.filter(Boolean).join '\n'

		when 'local'
			if tag or deploy is 'master'
				runTasks = async ->
					res.push await buildProd docsRoot
					res.push await packDist docsRoot
					res.push await gitCommitPushAndTag docsRoot, deploy, tag
					res.push await deployDocs docsRoot, deploy
					res.filter(Boolean).join '\n'
			else
				runTasks = async ->
					res.push await deployDocs docsRoot, deploy
					res.filter(Boolean).join '\n'

	# run it!
	# =======
	runTasks()



