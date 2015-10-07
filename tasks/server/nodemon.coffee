module.exports = (config) ->
	q       = require 'q'
	nodemon = require 'gulp-nodemon'

	# globals
	# =======
	rbServerFile = config.dist.rb.server.scripts.filePath
	watchDir     = config.dist.app.server.scripts.dir
	ignoreDirs = [
		config.node_modules.rb.dist.dir
		config.node_modules.app.dist.dir
		config.dist.rb.server.test.dir
		config.dist.app.server.test.dir
	]

	# API
	# ===
	api =
		runTask: ->
			defer = q.defer()
			nodemon
				script: rbServerFile
				ext:    'js json'
				watch:  watchDir # todo: watch isn't restarting on file deletion
				ignore: ignoreDirs

			.on 'start', ->
				browserSync = require "#{config.req.tasks}/browser/browser-sync"
				browserSync.delayedRestart()
				defer.resolve()

			defer.promise


	# return
	# ======
	api.runTask()
