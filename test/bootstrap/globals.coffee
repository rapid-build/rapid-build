# bootstrap global test rb config
# ===============================
module.exports = (config) ->
	# requires
	# ========
	Promise  = require 'bluebird'
	execSync = require('child_process').execSync
	fs       = Promise.promisifyAll require 'fs'

	# add to config
	# =============
	config.nm = { execSync, fs, Promise }

	# add it!
	# =======
	global.rb = config