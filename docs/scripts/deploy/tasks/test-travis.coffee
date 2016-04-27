module.exports = (docsRoot) ->
	os        = require 'os'
	path      = require 'path'
	async     = require 'asyncawait/async'
	await     = require 'asyncawait/await'
	fse       = require 'fs-extra'
	helpers   = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs   = require "#{helpers}/buffer-msgs"
	sshDir    = path.join os.homedir(), '.ssh'

	# tasks
	# =====
	testTravis = ->
		new Promise (resolve, reject) ->
			console.log 'SSH DIR:'.attn, sshDir
			files = fse.readdirSync sshDir
			console.log 'SSH FILES:'.attn, files
			resolve()

	# run tasks
	# =========
	runTasks = async ->
		await testTravis()
		'Tested Travis'

	# run it!
	# =======
	runTasks()

