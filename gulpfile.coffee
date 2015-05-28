# rapid sequence
# ==============
module.exports = (gulp, options={}) ->
	# try to load gulp from app's node_modules directory
	# if gulp isn't supplied, load it from rapid-build's node_modules
	# ===============================================================
	rbDir     = __dirname
	gulp      = require 'gulp' if not gulp
	bootstrap = require("#{rbDir}/bootstrap")()
	config    = require("#{rbDir}/config") rbDir, options
	tasks     = require("#{config.req.init}/tasks") gulp, config
	promise   = require("#{config.req.init}/rapid") gulp, config
	(env = 'default') -> # kick off rapid-build task
		gulp.start config.rb.tasks[env]
		promise