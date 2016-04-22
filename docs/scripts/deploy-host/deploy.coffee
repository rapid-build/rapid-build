# DEPLOY DOCS
# location = master | tag
# ========================
module.exports = (docsRoot, location) ->
	path  = require 'path'
	async = require 'asyncawait/async'
	await = require 'asyncawait/await'
	exec  = require('child_process').exec
	HOST  = require(path.join docsRoot, 'scripts', 'constants').host
	cmd   = "ssh #{HOST.login}@git.#{HOST.datacenter}.gpaas.net 'deploy #{HOST.vhost}.git #{location}'"

	# task
	# ====
	deploy = ->
		new Promise (resolve, reject) ->
			exec cmd, {}, (e, stdout, stderr) ->
				return reject e if e
				result = if typeof stderr is 'string' then stderr.replace(/\\n/g, '').trim() else ''
				resolve result

	# run task
	# ========
	runTask = async ->
		await deploy()

	# run it!
	# =======
	runTask()



