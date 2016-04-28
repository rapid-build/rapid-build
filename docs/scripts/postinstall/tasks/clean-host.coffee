module.exports = (docsRoot) ->
	del  = require 'del'
	path = require 'path'
	dist = path.join docsRoot, 'dist.zip'

	# task
	# ====
	runTask = ->
		new Promise (resolve, reject) ->
			del(dist, force:true).then (paths) ->
				resolve 'Cleaned Host'

	# run it!
	# =======
	runTask()