module.exports = (config, gulp, Task) ->
	q           = require 'q'
	path        = require 'path'
	nodemon     = require 'gulp-nodemon'
	taskManager = require("#{config.req.manage}/task-manager") config, gulp

	# globals
	# =======
	rbServerFile = config.dist.rb.server.scripts.start
	watchDir     = config.dist.app.server.scripts.dir

	serverInfo   = path.join config.dist.rb.server.scripts.dir, 'server-info.json'
	# Has default ignore list (like node_modules):
	# https://github.com/remy/nodemon#user-content-ignoring-files
	ignoreFiles  = [ serverInfo ]
	ignoreDirs   = [
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
				defer.resolve
					# log: 'minor'
					message: "completed task: #{Task.name}"

			.on 'restart', ->
				taskManager.runWatchTask 'browser-sync', run: 'delayedRestart'

			defer.promise

	# return
	# ======
	api.runTask()
