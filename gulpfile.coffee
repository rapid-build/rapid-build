# rapid sequence
# ==============
module.exports = (options={}) ->
	rbDir     = __dirname
	gulp      = require 'gulp'
	bootstrap = require("#{rbDir}/bootstrap")()
	config    = require("#{rbDir}/config") rbDir, options
	tasks     = require("#{config.req.init}/tasks") gulp, config
	promise   = require("#{config.req.init}/rapid") gulp, config
	(env = 'default') -> # kick off rapid-build task
		gulp.start config.rb.tasks[env]
		promise