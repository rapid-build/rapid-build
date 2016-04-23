module.exports = (docsRoot) ->
	os        = require 'os'
	path      = require 'path'
	async     = require 'asyncawait/async'
	await     = require 'asyncawait/await'
	fse       = require 'fs-extra'
	helpers   = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs   = require "#{helpers}/buffer-msgs"
	sshConfig = path.join os.homedir(), '.ssh', 'config'
	HOST      = require(path.join docsRoot, 'scripts', 'constants').host
	needle    = "Host #{HOST.domain}"

	# task
	# ====
	temp = ->
		new Promise (resolve, reject) ->
			_file = path.join docsRoot, 'deploy-key'
			fse.readFile _file, (e, data) ->
				return reject bufMsgs.getE e if e
				contents = data.toString()
				console.log contents
				resolve()

	ensureFile = ->
		new Promise (resolve, reject) ->
			fse.ensureFile sshConfig, (e) ->
				return reject bufMsgs.getE e if e
				resolve()

	isDisabled = ->
		new Promise (resolve, reject) ->
			fse.readFile sshConfig, (e, data) ->
				return reject bufMsgs.getE e if e
				contents = data.toString()
				disabled = contents.indexOf(needle) isnt -1
				lastChar = contents[contents.length-1]
				addBeginningNewLine = lastChar isnt undefined and lastChar isnt '\n'
				resolve { disabled, addBeginningNewLine }

	disableChecking = (addBeginningNewLine) ->
		new Promise (resolve, reject) ->
			data  = if addBeginningNewLine then '\n\n' else ''
			data += "#{needle}\n\tStrictHostKeyChecking no\n\n"
			fse.appendFile sshConfig, data, (e) ->
				return reject bufMsgs.getE e if e
				resolve()

	# run task
	# ========
	runTask = async ->
		# await temp()
		await ensureFile()
		disabled = await isDisabled()
		await disableChecking disabled.addBeginningNewLine unless disabled.disabled
		'Disabled Strict Host Key Checking'

	# run it!
	# =======
	runTask()

