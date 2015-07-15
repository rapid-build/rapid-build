module.exports = (config) ->
	path       = require 'path'
	rbConfig   = require '../../config/config.json'
	moduleHelp = require "#{rbConfig.req.helpers}/module"

	# helpers
	# =======
	getScripts = (jsonEnvFile) ->
		jsonEnvFile = path.join rbConfig.templates.files.dest.dir, jsonEnvFile
		moduleHelp.cache.delete jsonEnvFile
		scripts = require(jsonEnvFile).client.scripts
		scripts.push(
			rbConfig.glob.dist.rb.client.test.js
			rbConfig.glob.dist.app.client.test.js
		)
		scripts

	# return
	# ======
	config.set
		autoWatch: false
		basePath: rbConfig.app.dir
		files: getScripts 'files.json'
		frameworks: ['jasmine']
		browsers: ['PhantomJS'] # 'Chrome', 'Firefox', 'IE', 'Safari'
		singleRun: true
