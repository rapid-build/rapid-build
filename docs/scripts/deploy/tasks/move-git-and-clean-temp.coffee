module.exports = (docsRoot) ->
	path    = require 'path'
	exec    = require('child_process').exec
	helpers = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs = require "#{helpers}/buffer-msgs"
	cmd     = 'mv _temp/.git .'
	cmd    += ' && '
	cmd    += 'rm -rf _temp'

	# task
	# ====
	runTask = ->
		new Promise (resolve, reject) ->
			exec cmd, {}, (e, stdout, stderr) ->
				msgs = bufMsgs.get e, stdout, stderr
				return reject msgs.e if e
				res  = msgs.stds or 'Moved Git and Deleted _temp'
				resolve res

	# run it!
	# =======
	runTask()