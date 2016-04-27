module.exports = (docsRoot) ->
	path    = require 'path'
	exec    = require('child_process').exec
	helpers = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs = require "#{helpers}/buffer-msgs"
	keyEnc  = path.join docsRoot, 'deploy-key.enc'
	keyDec  = path.join docsRoot, 'deploy-key'
	cmd     = 'openssl aes-256-cbc '
	cmd    += '-K $encrypted_18cf70cd38e2_key '
	cmd    += '-iv $encrypted_18cf70cd38e2_iv '
	cmd    += "-in #{keyEnc} -out #{keyDec} -d"

	# task
	# ====
	runTask = ->
		new Promise (resolve, reject) ->
			exec cmd, {}, (e, stdout, stderr) ->
				msgs = bufMsgs.get e, stdout, stderr
				return reject msgs.e if e
				res  = msgs.stds or 'Deploy Key Decrypted'
				resolve res

	# run it!
	# =======
	runTask()