module.exports = (config, gulp, Task) ->
	promiseHelp = require "#{config.req.helpers}/promise"
	return promiseHelp.get() if config.exclude.default.server.files

	# requires
	# ========
	q = require 'q'

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			src   = config.generated.pkg.config
			dest  = config.dist.rb.server.scripts.dir
			gulp.src src
				.on 'error', (e) -> defer.reject e
				.pipe gulp.dest dest
				.on 'end', ->
					defer.resolve
						# log: 'minor'
						message: "copied server config to: #{dest}/config.json"
			defer.promise

	# return
	# ======
	api.runTask()