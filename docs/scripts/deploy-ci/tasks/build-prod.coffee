module.exports = (docsRoot) ->
	path    = require 'path'
	exec    = require('child_process').exec
	helpers = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs = require "#{helpers}/buffer-msgs"
	cmd     = 'node build prod'

	# task
	# ====
	runTask = ->
		new Promise (resolve, reject) ->
			exec cmd, {}, (e, stdout, stderr) ->
				msgs = bufMsgs.get e, stdout, stderr
				return reject "#{msgs.e}" if e
				res  = msgs.stds or 'Prod Built'
				resolve res

	# run it!
	# =======
	runTask()