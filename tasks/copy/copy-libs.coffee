module.exports = (gulp, config) ->
	q           = require 'q'
	es          = require 'event-stream'
	bowerHelper = require("#{config.req.helpers}/bower") config

	removeMin = -> # for prod env, to avoid additional work elsewhere
		transform = (file, cb) ->
			file.path = file.path.replace '.min', ''
			cb null, file
		es.map transform

	runTask = (src, dest) ->
		defer = q.defer()
		gulp.src src
			.pipe removeMin()
			.pipe gulp.dest dest
			.on 'end', ->
				# console.log dest
				defer.resolve()
		defer.promise

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}copy-libs", ->
		bowerLibs = bowerHelper.get.src()
		runTask bowerLibs, config.dist.rb.client.libs.dir


