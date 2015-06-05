module.exports = (gulp, config, browserSync) ->
	q       = require 'q'
	path    = require 'path'
	nodemon = require 'gulp-nodemon'

	rbServerFile = path.join(
		config.dist.rb.server.scripts.dir,
		config.dist.rb.server.scripts.file
	)

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}server-nodemon", ->
		defer = q.defer()
		nodemon
			script: rbServerFile
			ext: 'js json'
			# todo: watch isn't restarting on file deletion
			watch: config.dist.app.server.scripts.dir
			ignore: config.node_modules.dist.dir

		.on 'start', ->
			browserSync.emitter._events.serverRestart() if browserSync
			defer.resolve()

		defer.promise