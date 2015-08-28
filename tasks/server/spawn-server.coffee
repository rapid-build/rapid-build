module.exports = (gulp, config) ->
	q            = require 'q'
	path         = require 'path'
	rbServerFile = path.join config.app.dir, config.dist.rb.server.scripts.path

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}spawn-server", ->
		defer = q.defer()
		require rbServerFile
		defer.resolve()
		defer.promise