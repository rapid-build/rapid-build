module.exports = (config, gulp) ->
	q = require 'q'

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			src   = config.templates.config.dest.path
			dest  = config.dist.rb.server.scripts.dir
			gulp.src src
				.pipe gulp.dest dest
				.on 'end', ->
					# console.log dest
					defer.resolve()
			defer.promise

	# return
	# ======
	api.runTask()