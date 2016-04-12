module.exports = (config, gulp) ->
	q           = require 'q'
	promiseHelp = require "#{config.req.helpers}/promise"

	# API
	# ===
	api =
		runTask: ->
			return promiseHelp.get() if config.exclude.default.server.files
			defer = q.defer()
			src   = config.generated.pkg.src.server.info
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