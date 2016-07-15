module.exports = (config, gulp, taskOpts={}) ->
	q            = require 'q'
	del          = require 'del'
	log          = require "#{config.req.helpers}/log"
	forWatchFile = !!taskOpts.watchFile

	# API
	# ===
	api =
		runSingle: ->
			defer = q.defer()
			src   = taskOpts.watchFile.rbDistPath
			del(src, force:true).then (paths) ->
				defer.resolve()
			defer.promise

		runMulti: ->
			defer = q.defer()
			del(config.dist.dir, force:true).then (paths) ->
				# log.task "cleaned #{config.dist.dir} directory", 'minor'
				defer.resolve()
			defer.promise

	# return
	# ======
	return api.runSingle() if forWatchFile
	api.runMulti()