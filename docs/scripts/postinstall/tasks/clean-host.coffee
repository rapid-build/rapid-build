module.exports = (docsRoot) ->
	del      = require 'del'
	path     = require 'path'
	delFiles = [
		path.join docsRoot, '.nvmrc'
		path.join docsRoot, '.gitignore'
		path.join docsRoot, 'scripts'
		path.join docsRoot, 'dist.zip'
		path.join docsRoot, 'node_modules'
	]

	# tasks
	# =====
	getIsLocal = ->
		try
			rbPkgName = require(path.resolve docsRoot, '..', 'package.json').name
			isLocal   = rbPkgName is 'rapid-build'
		catch e
			isLocal = false
		isLocal

	runTask = ->
		msg     = 'Cleaned Host'
		isLocal = getIsLocal()

		new Promise (resolve, reject) ->
			return resolve msg if isLocal
			del(delFiles, force:true).then (paths) ->
				resolve msg

	# run it!
	# =======
	runTask()