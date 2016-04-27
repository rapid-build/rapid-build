module.exports = (docsRoot) ->
	os        = require 'os'
	path      = require 'path'
	async     = require 'asyncawait/async'
	await     = require 'asyncawait/await'
	fse       = require 'fs-extra'
	helpers   = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs   = require "#{helpers}/buffer-msgs"
	sshDir    = path.join os.homedir(), '.ssh'
	sshKey    = path.join sshDir, 'id_rsa'

	# tasks
	# =====
	testTravis1 = ->
		new Promise (resolve, reject) ->
			console.log 'SSH DIR:'.attn, sshDir
			files = fse.readdirSync sshDir
			console.log 'SSH FILES:'.attn, files
			resolve()

	testTravis2 = ->
		new Promise (resolve, reject) ->
			file = fse.readFileSync sshKey
			console.log 'SSH Key:'.attn
			console.log file.toString()
			resolve()

	# run tasks
	# =========
	runTasks = async ->
		await testTravis1()
		# await testTravis2()
		'Tested Travis'

	# run it!
	# =======
	runTasks()

