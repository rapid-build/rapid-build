module.exports = (config) ->
	q   = require 'q'
	del = require 'del'

	# API
	# ===
	api =
		runTask: (src) ->
			defer = q.defer()
			del(src, force:true).then (paths) ->
				# console.log 'files.json deleted'.yellow
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask config.generated.pkg.files.files


