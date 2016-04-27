module.exports = (docsRoot) ->
	path    = require 'path'
	exec    = require('child_process').exec
	helpers = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs = require "#{helpers}/buffer-msgs"
	HOST    = require(path.join docsRoot, 'scripts', 'constants').host
	cmd     = 'git clone --depth 1 '
	cmd    += "git+ssh://#{HOST.login}@git.#{HOST.datacenter}.gpaas.net/#{HOST.vhost}.git "
	cmd    += '_temp'

	# task
	# ====
	runTask = ->
		new Promise (resolve, reject) ->
			exec cmd, {}, (e, stdout, stderr) ->
				msgs = bufMsgs.get e, stdout, stderr
				return reject msgs.e if e
				res  = msgs.stds or 'Shallow Cloned Host\'s Docs Repo'
				resolve res

	# run it!
	# =======
	runTask()