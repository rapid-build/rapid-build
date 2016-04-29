module.exports = (docsRoot, deploy, tag=false) ->
	path     = require 'path'
	exec     = require('child_process').exec
	helpers  = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs  = require "#{helpers}/buffer-msgs"
	cmd      = 'git add .'
	cmd     += ' && '
	if tag
		cmd += "git commit -am \"chore(bump): #{deploy}\""
		cmd += ' && '
		cmd += 'git push'
		cmd += ' && '
		cmd += "git tag -a #{deploy} -m \"chore(tag): #{deploy}\""
		cmd += ' && '
		cmd += "git push origin #{deploy}"
		msg  = 'Git Committed, Pushed and Tagged'
	else
		cmd += "git commit -am \"chore(deploy): master\""
		cmd += ' && '
		cmd += 'git push'
		msg  = 'Git Committed and Pushed'

	# task
	# ====
	runTask = ->
		new Promise (resolve, reject) ->
			exec cmd, {}, (e, stdout, stderr) ->
				msgs = bufMsgs.get e, stdout, stderr
				return reject msgs.e if e
				res  = msgs.stds or msg
				resolve res

	# run it!
	# =======
	runTask()