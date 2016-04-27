module.exports = (docsRoot) ->
	os      = require 'os'
	path    = require 'path'
	exec    = require('child_process').exec
	helpers = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs = require "#{helpers}/buffer-msgs"
	keyDec  = path.join docsRoot, 'deploy-key'
	id_rsa  = path.join os.homedir(), '.ssh', 'id_rsa'
	cmd     = "mv #{keyDec} #{id_rsa}"

	# task
	# ====
	runTask = ->
		new Promise (resolve, reject) ->
			exec cmd, {}, (e, stdout, stderr) ->
				msgs = bufMsgs.get e, stdout, stderr
				return reject msgs.e if e
				res  = msgs.stds or 'Added Deploy Key'
				resolve res

	# run it!
	# =======
	runTask()