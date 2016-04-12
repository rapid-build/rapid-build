module.exports = (config) ->
	q       = require 'q'
	path    = require 'path'
	nodemon = require 'gulp-nodemon'

	# globals
	# =======
	rbServerFile = config.dist.rb.server.scripts.start
	watchDir     = config.dist.app.server.scripts.dir

	serverInfo   = path.join config.dist.rb.server.scripts.dir, 'server-info.json'
	ignoreFiles  = [ serverInfo ]
	ignoreDirs   = [
		config.node_modules.rb.dist.dir
		config.node_modules.app.dist.dir
		config.dist.rb.server.test.dir
		config.dist.app.server.test.dir
	]
	ignore = [].concat ignoreFiles, ignoreDirs

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			nodemon
				script: rbServerFile
				ext:    'js json'
				watch:  watchDir # todo: watch isn't restarting on file deletion
				ignore: ignore

			.on 'start', ->
				browserSync = require "#{config.req.tasks}/browser/browser-sync"
				browserSync.delayedRestart()
				defer.resolve()

			defer.promise


	# return
	# ======
	api.runTask()
