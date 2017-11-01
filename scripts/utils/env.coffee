# ENVIRONMENT HELPER
# ==================
q      = require 'q'
exec   = require('child_process').exec
fse    = require 'fs-extra'
semver = require 'semver'
consts = require '../consts/consts'
log    = require './log'

# module
# ======
module.exports =
	getNpmVersion: -> # :promise<string>
		new Promise (resolve, reject) ->
			exec 'npm --version', (err, stdout, stderr) ->
				return reject err if err
				version = stdout.trim()
				log.msg "running npm: v#{version}"
				resolve version

	isConsumer: (silent=false) -> # :promise<boolean>
		# published package doesn't have root/src/
		fse.pathExists(consts.RB_SRC).then (exists) ->
			exists = !exists
			log.msg "is consumer install: #{exists}" unless silent
			exists

	isNpmVersion: (versionRange) -> # :promise<boolean>
		@getNpmVersion().then (version) ->
			inRange = semver.satisfies version, versionRange
			log.msg "is npm v#{version} in range #{versionRange}: #{inRange}"
			inRange



