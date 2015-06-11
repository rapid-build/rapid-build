module.exports = (gulp, config) ->
	q   = require 'q'
	del = require 'del'

	runTask = (src) ->
		defer = q.defer()
		del src, force:true, (e) ->
			# console.log 'files.json deleted'.yellow
			defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}clean-files", ->
		runTask config.templates.files.dest.path


