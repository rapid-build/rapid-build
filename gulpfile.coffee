# rapid sequence
# ==============
module.exports = (options={}) ->
	# try to load gulp from app's node_modules directory
	# if it isn't there, load it from rapid-build's node_modules
	# ==========================================================
	try
		gulp = require '../gulp'
	catch e
		gulp = require 'gulp'
	rbDir     = __dirname
	bootstrap = require("#{rbDir}/bootstrap")()
	config    = require("#{rbDir}/config") rbDir, options
	tasks     = require("#{config.req.init}/tasks") gulp, config
	promise   = require("#{config.req.init}/rapid") gulp, config
	(env = 'default') -> # kick off rapid-build task
		gulp.start config.rb.tasks[env]
		promise