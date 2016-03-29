# build sequence
# ==============
module.exports = (gulp, options={}) ->
	# try to load gulp from app's node_modules directory
	# if gulp isn't supplied, load it from the build's node_modules
	# =============================================================
	rbDir     = __dirname
	gulp      = require 'gulp' unless gulp
	bootstrap = require("#{rbDir}/bootstrap")()
	config    = require("#{rbDir}/config/config") rbDir, options
	tasks     = require("#{config.req.init}/tasks") gulp, config
	promise   = require("#{config.req.init}/api") gulp, config

	# sequence:
	# 1. init build
	# 2. execute to kick off the build
	# 3. return promise when build is complete
	#
	# note: function not executed if app calls build task from gulp
	# example - gulpfile.js:
	#   gulp.task 'default', [config.rb.tasks.dev]
	#
	# example - build.js:
	#   terminal: node build dev
	#   build.js:
	#     buildMode = process.argv[2]
	#     build     = require(config.rb.name) opts
	#     build(buildMode).done -> console.log 'build finished'
	# =============================================================
	(env = 'default') ->
		gulp.start config.rb.tasks[env]
		promise