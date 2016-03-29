module.exports = (config) ->
	q    = require 'q'
	del  = require 'del'
	path = require 'path'

	cleanTask = (src) ->
		defer = q.defer()
		del(src, force:true).then (paths) ->
			# console.log 'cleaned rb test src'.yellow
			defer.resolve()
		defer.promise

	# API
	# ===
	api =
		runTask: -> # all files are generated
			dest = config.src.rb.client.test.dir
			src  = [
				path.join dest, '*'
				path.join "!#{dest}", '.gitkeep'
			]
			cleanTask src

	# return
	# ======
	api.runTask()

