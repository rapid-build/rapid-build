module.exports = (config, gulp, Task) ->
	del = require 'del'

	# API
	# ===
	api =
		runTask: ->
			src = config.generated.pkg.files.files
			del(src, force:true).then (paths) ->
				# log: 'minor'
				message: "deleted files.json"

	# return
	# ======
	api.runTask()


