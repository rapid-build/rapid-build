module.exports = (docsRoot) ->
	path    = require 'path'
	exec    = require('child_process').exec
	helpers = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs = require "#{helpers}/buffer-msgs"
	GIT     = require(path.join docsRoot, 'scripts', 'constants').git
	cmd     = "git config --global user.name '#{GIT.name}' "
	cmd    += '&& '
	cmd    += "git config --global user.email '#{GIT.email}'"

	# task
	# ====
	runTask = ->
		new Promise (resolve, reject) ->
			exec cmd, {}, (e, stdout, stderr) ->
				msgs = bufMsgs.get e, stdout, stderr
				return reject "#{msgs.e}" if e
				res  = msgs.stds or 'Git Config User Info Set'
				resolve res

	# run it!
	# =======
	runTask()