module.exports = (docsRoot) ->
	path    = require 'path'
	zipdir  = require 'zip-dir'
	helpers = path.join docsRoot, 'scripts', 'helpers'
	bufMsgs = require "#{helpers}/buffer-msgs"
	distDir = path.join docsRoot, 'dist'
	distZip = path.join docsRoot, 'dist.zip'
	opts    = saveTo: distZip

	# task
	# ====
	runTask = ->
		new Promise (resolve, reject) ->
			zipdir distDir, opts, (e, buffer) ->
				return reject bufMsgs.getE e if e
				resolve 'Packed Dist'

	# run it!
	# =======
	runTask()
