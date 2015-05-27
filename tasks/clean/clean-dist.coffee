module.exports = (gulp, config, file={}) ->
	q       = require 'q'
	del     = require 'del'
	forFile = !!file.path

	runSingle = ->
		defer = q.defer()
		del file.rbDistPath, force:true, (e) ->
			defer.resolve()
		defer.promise

	runMulti = ->
		defer = q.defer()
		del config.dist.dir, force:true, (e) ->
			defer.resolve()
		defer.promise

	return runSingle() if forFile
	gulp.task "#{config.rb.prefix.task}clean-dist", -> runMulti()