module.exports = (docsRoot) ->
	path    = require 'path'
	unzip   = require 'extract-zip'
	helpers = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs = require "#{helpers}/buffer-msgs"
	distDir = path.join docsRoot, 'dist'
	distZip = path.join docsRoot, 'dist.zip'
	opts    = dir: distDir

	# task
	# ====
	runTask = ->
		new Promise (resolve, reject) ->
			unzip distZip, opts, (e) ->
				return reject bufMsgs.getE e if e
				resolve 'Unpacked Dist'

	# run it!
	# =======
	runTask()