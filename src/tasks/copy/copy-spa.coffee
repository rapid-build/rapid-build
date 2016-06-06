module.exports = (config, gulp) ->
	q   = require 'q'
	fse = require 'fs-extra'

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			src   = config.spa.src.path
			dest  = config.spa.temp.path
			opts  = clobber: true
			fse.copy src, dest, opts, (e) ->
				defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()