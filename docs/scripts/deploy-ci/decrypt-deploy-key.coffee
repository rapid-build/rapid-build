module.exports = (docsRoot) ->
	path    = require 'path'
	async   = require 'asyncawait/async'
	await   = require 'asyncawait/await'
	exec    = require('child_process').exec
	helpers = path.join docsRoot, 'scripts', 'helpers'
	keyEnc  = path.join docsRoot, 'deploy-key.enc'
	key     = path.join docsRoot, 'deploy-key'
	log     = require "#{helpers}/log"
	cmd     = 'openssl aes-256-cbc -K $encrypted_18cf70cd38e2_key -iv $encrypted_18cf70cd38e2_iv '
	cmd    += "-in #{keyEnc} -out #{key} -d"

	# task
	# ====
	task = ->
		new Promise (resolve, reject) ->
			exec cmd, {}, (e, stdout, stderr) ->
				return reject e if e
				result = if typeof stderr is 'string' then stderr.replace(/\\n/g, '').trim() else ''
				resolve result

	# run task
	# ========
	runTask = async ->
		decrypt = await task()

	# run it!
	# =======
	runTask().then (result) ->
		console.log result
		log 'Decrypted Deploy Key'
	.catch (e) ->
		log 'Failed to Decrypt Deploy Key', 'error'
		console.error "Error: #{e.message}".error