module.exports = (config, gulp, Task) ->
	fse = require 'fs-extra'

	# API
	# ===
	api =
		runTask: ->
			src  = config.spa.src.path
			dest = config.spa.temp.path
			opts = overwrite: true
			fse.copy(src, dest, opts).then ->
				# log: 'minor'
				message: "copied spa to: #{config.generated.pkg.temp.relPath}"

	# return
	# ======
	api.runTask()