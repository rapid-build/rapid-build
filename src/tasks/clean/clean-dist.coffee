module.exports = (config, gulp, Task) ->
	forWatchFile = !!Task.opts.watchFile

	# requires
	# ========
	del = require 'del'

	# API
	# ===
	api =
		runSingle: ->
			src = Task.opts.watchFile.rbDistPath
			del(src, force:true).then (paths) ->
				# log: 'minor'
				message: "cleaned: #{src}"

		runMulti: ->
			del(config.dist.dir, force:true).then (paths) ->
				# log: 'minor'
				message: "cleaned #{config.dist.dir} directory"

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()