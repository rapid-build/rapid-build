module.exports = (gulp, config, watchFile={}) ->
	q            = require 'q'
	del          = require 'del'
	forWatchFile = !!watchFile.path

	runSingle = ->
		defer = q.defer()
		del watchFile.rbDistPath, force:true, (e) ->
			defer.resolve()
		defer.promise

	runMulti = ->
		defer = q.defer()
		del config.dist.dir, force:true, (e) ->
			defer.resolve()
		defer.promise

	# register task
	# =============
	return runSingle() if forWatchFile
	gulp.task "#{config.rb.prefix.task}clean-dist", -> runMulti()