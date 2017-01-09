# UNPACK LIB SERVER
# =================
module.exports = (rbRoot) ->
	path    = require 'path'
	del     = require 'del'
	async   = require 'asyncawait/async'
	await   = require 'asyncawait/await'
	Promise = require 'bluebird'
	tar     = require 'tar'
	fstream = require 'fstream' # used in github tar examples
	log     = require '../utils/log'
	fse     = Promise.promisifyAll require 'fs-extra'

	# consts
	# ======
	LIB        = "#{rbRoot}/lib" # lib is created from src
	NMS        = "node_modules"
	SERVER     = "src/server"
	LIB_SERVER = "#{LIB}/#{SERVER}"
	PKG_NAME   = 'server.tgz'
	PKG_PATH   = "#{LIB_SERVER}/#{PKG_NAME}"
	DEL_OPTS   = force: true

	# tasks
	# =====
	tasks =
		isLocalInstall: ->
			# reason for this (suppress local install error):
			# postinstall runs before prepublish and prepublish creates lib
			localSrcPath = path.resolve __dirname, '..', '..', 'src'
			fse.statAsync(localSrcPath).then ->
				log.msg 'is local install'
				test: true
			.catch (e) ->
				log.msg 'is not local install'
				{ test: false, e }

		serverPkg:
			cleanDir: ->
				src = ["#{LIB_SERVER}/*", "!#{PKG_PATH}"]
				del(src, DEL_OPTS).then (_paths) ->
					log.msg 'cleaned pkg directory'

			exists: ->
				fse.statAsync(PKG_PATH).then ->
					log.msg 'server pkg exist'
					test: true
				.catch (e) ->
					log.msg 'server pkg doesn\'t exist'
					{ test: false, e }

			unpack: ->
				src  = "#{LIB_SERVER}/#{PKG_NAME}"
				dest = LIB_SERVER
				opts =
					extractor: path: dest
					reader: path: src, type: 'File'

				new Promise (resolve, reject) ->
					onError = (e) ->
						reject e

					onEnd = ->
						log.msg "unpacked #{PKG_NAME}"
						resolve()

					extractor = tar.Extract opts.extractor
								.on 'error', onError
								.on 'end', onEnd

					fstream.Reader opts.reader
						.on 'error', onError
						.pipe extractor

	# run tasks (in order, synchronously)
	# ===================================
	runTasks = async ->
		pkgExists      = await tasks.serverPkg.exists()
		isLocalInstall = await tasks.isLocalInstall()
		if not pkgExists.test and isLocalInstall.test
			message = 'skipped unpacking pkg (will get created via prepublish -> lib-create)'
			log.msg message
			return { message }
		await tasks.serverPkg.cleanDir()
		await tasks.serverPkg.unpack()
		# success return
		message: 'unpacked lib server'

	# run it!
	# =======
	runTasks()



