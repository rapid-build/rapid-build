module.exports = (gulp, config) ->
	q            = require 'q'
	path         = require 'path'
	rbServerFile = config.dist.rb.server.scripts.filePath

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}spawn-server", ->
		defer = q.defer()
		require rbServerFile
		defer.resolve()
		defer.promise