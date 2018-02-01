module.exports = (config, gulp, Task) ->
	del  = require 'del'
	path = require 'path'

	# API
	# ===
	api =
		runTask: -> # all files are generated
			dest = config.src.rb.client.test.dir
			src  = [
				path.join dest, '*'
				path.join "!#{dest}", '.gitkeep'
			]
			del(src, force:true).then (paths) ->
				# log: 'minor'
				message: 'cleaned rb test src'

	# return
	# ======
	api.runTask()

