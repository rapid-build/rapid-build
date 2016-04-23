module.exports = (docsRoot) ->
	path    = require 'path'
	async   = require 'asyncawait/async'
	await   = require 'asyncawait/await'
	exec    = require('child_process').exec
	helpers = path.join docsRoot, 'scripts', 'helpers'
	log     = require "#{helpers}/log"
	cmd     = 'echo "Host git.dc1.gpaas.net\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config'

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
		await task()

	# run it!
	# =======
	runTask().then (result) ->
		console.log result
		log 'Disabled Strict Host Key Checking'
	.catch (e) ->
		log 'Failed to Disable Strict Host Key Checking', 'error'
		console.error "Error: #{e.message}".error