module.exports = (docsRoot) ->
	path    = require 'path'
	exec    = require('child_process').exec
	helpers = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs = require "#{helpers}/buffer-msgs"
	pkgPath = path.join docsRoot, 'package.json' # docs package.json
	pkg     = require pkgPath
	tag     = "v#{pkg.version}"
	tag     = "v0.1.6" # temp

	cmd     = 'git add .'
	cmd    += ' && '
	cmd    += "git commit -am \"chore(bump): #{tag}\""
	cmd    += ' && '
	cmd    += 'git push'
	cmd    += ' && '
	cmd    += "git tag -a #{tag} -m \"chore(tag): #{tag}\""
	cmd    += ' && '
	cmd    += "git push origin #{tag}"

	# task
	# ====
	runTask = ->
		new Promise (resolve, reject) ->
			exec cmd, {}, (e, stdout, stderr) ->
				msgs = bufMsgs.get e, stdout, stderr
				return reject "#{msgs.e}" if e
				res  = msgs.stds or 'Git Committed, Pushed and Tagged'
				resolve res

	# run it!
	# =======
	runTask()