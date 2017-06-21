# ENVIRONMENT HELPER
# ==================
exec   = require('child_process').exec
fse    = require 'fs-extra'
async  = require 'asyncawait/async'
await  = require 'asyncawait/await'
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

	isConsumer: async (silent=false) -> # :promise<boolean>
		exists = await fse.pathExists consts.RB_SRC # published package doesn't have root/src/
		exists = !exists
		log.msg "is consumer install: #{exists}" unless silent
		exists

	isNpmVersion: async (versionRange) -> # :promise<boolean>
		version = await @getNpmVersion()
		inRange = semver.satisfies version, versionRange
		log.msg "is npm v#{version} in range #{versionRange}: #{inRange}"
		inRange



