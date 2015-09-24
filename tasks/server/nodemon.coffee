module.exports = (gulp, config, browserSync) ->
	q           = require 'q'
	path        = require 'path'
	nodemon     = require 'gulp-nodemon'
	promiseHelp = require "#{config.req.helpers}/promise"

	# globals
	# =======
	rbServerFile = config.dist.rb.server.scripts.path
	watchDir     = config.dist.app.server.scripts.dir
	ignoreDirs = [
		config.node_modules.rb.dist.dir
		config.node_modules.app.dist.dir
	]

	# register task
	# =============
	gulp.task "#{config.rb.prefix.task}nodemon", ->
		return promiseHelp.get() unless config.build.server
		defer = q.defer()
		nodemon
			script: rbServerFile
			ext:    'js json'
			watch:  watchDir # todo: watch isn't restarting on file deletion
			ignore: ignoreDirs

		.on 'start', ->
			browserSync.emitter._events.serverRestart() if browserSync
			defer.resolve()

		defer.promise