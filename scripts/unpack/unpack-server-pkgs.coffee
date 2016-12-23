# UNPACK LIB SERVER PKGS
# ======================
module.exports = (rbRoot) ->
	async   = require 'asyncawait/async'
	await   = require 'asyncawait/await'
	Promise = require 'bluebird'
	tar     = require 'tar'
	fse     = Promise.promisifyAll require 'fs-extra'

	# consts
	# ======
	LIB        = "#{rbRoot}/lib" # lib is created from src
	NMS        = "node_modules"
	SERVER     = "src/server"
	LIB_SERVER = "#{LIB}/#{SERVER}"
	LIB_NMS    = "#{LIB_SERVER}/#{NMS}"

	# tasks
	# =====
	tasks =
		lib:
			serverPks:
				unpack: ->
					pkg     = require "#{LIB_SERVER}/package.json"
					pkgName = "#{pkg.name}-pkgs.tgz"
					src     = "#{LIB_SERVER}/#{pkgName}"
					dest    = LIB_SERVER

					new Promise (resolve, reject) ->
						onError = (e) ->
							reject e

						onEnd = ->
							console.log "unpacked #{pkgName}".info
							resolve()

						extractor = tar.Extract path: dest
									.on 'error', onError
									.on 'end', onEnd

						fse.createReadStream src
							.on 'error', onError
							.pipe extractor

	# run tasks (in order, synchronously)
	# ===================================
	runTasks = async ->
		await tasks.lib.serverPks.unpack()

	# run it!
	# =======
	runTasks()



