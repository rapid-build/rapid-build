# rapid sequence
# ==============
module.exports = (gulp, options={}) ->
	# try to load gulp from app's node_modules directory
	# if gulp isn't supplied, load it from rapid-build's node_modules
	# ===============================================================
	rbDir     = __dirname
	gulp      = require 'gulp' unless gulp
	bootstrap = require("#{rbDir}/bootstrap")()
	config    = require("#{rbDir}/config") rbDir, options
	tasks     = require("#{config.req.init}/tasks") gulp, config
	promise   = require("#{config.req.init}/rapid") gulp, config

	# sequence:
	# 1. init rapid
	# 2. execute rapid to kick off the build
	# 3. return promise when build is complete
	#
	# note: function not executed if app calls build task from gulp
	# example - gulpfile.js:
	#   gulp.task 'default', ['rapid-build:dev']
	#
	# example - build.js:
	#   terminal: node build dev
	#   build.js:
	#     build = process.argv[2]
	#     rapid = require('rapid-build') opts
	#     rapid(build).done -> console.log 'build finished'
	# =============================================================
	(env = 'default') ->
		gulp.start config.rb.tasks[env]
		promise