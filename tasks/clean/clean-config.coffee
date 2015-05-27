module.exports = (gulp, config) ->
	q   = require 'q'
	del = require 'del'

	runTask = (src) ->
		defer = q.defer()
		del src, force:true, (e) ->
			# console.log 'config.json deleted'.yellow
			defer.resolve()
		defer.promise

	gulp.task "#{config.rb.prefix.task}clean-config", ->
		runTask config.json.config.path


