# DEPLOY DOCS
# ===========
module.exports = (location) ->
	async   = require 'asyncawait/async'
	await   = require 'asyncawait/await'
	exec    = require('child_process').exec
	login   = '204265'
	vhost   = 'default'
	dCenter = 'dc1' # data center location
	cmd     = "ssh #{login}@git.#{dCenter}.gpaas.net 'deploy #{vhost}.git #{location}'"

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



