# CREATE LIB
# ==========
module.exports = (rbRoot) ->
	del      = require 'del'
	gulp     = require 'gulp'
	coffee   = require 'gulp-coffee'
	minifyJs = require 'gulp-uglify'
	async    = require 'asyncawait/async'
	await    = require 'asyncawait/await'
	Promise  = require 'bluebird'
	tar      = require 'tar'
	fstream  = require 'fstream' # used in github tar examples
	log      = require '../utils/log'
	fse      = Promise.promisifyAll require 'fs-extra'

	# consts
	# ======
	SRC        = "#{rbRoot}/src"
	LIB        = "#{rbRoot}/lib" # lib is created from src
	NMS        = "node_modules"
	SERVER     = "src/server"
	SRC_SERVER = "#{SRC}/#{SERVER}"
	LIB_SERVER = "#{LIB}/#{SERVER}"
	SRC_NMS    = "#{SRC_SERVER}/#{NMS}"
	LIB_NMS    = "#{LIB_SERVER}/#{NMS}"
	DEL_OPTS   = force: true

	# globs
	# =====
	glob =
		lib:
			js:     ["#{LIB}/**/*.js",     "!#{LIB_NMS}/**"]
			coffee: ["#{LIB}/**/*.coffee", "!#{LIB_NMS}/**"]

	# tasks
	# =====
	tasks =
		lib:
			clean: ->
				del(LIB, DEL_OPTS).then (_paths) ->
					log.msg 'lib cleaned'

			compileCoffee: ->
				src  = glob.lib.coffee
				dest = LIB
				opts = bare: true
				promise = new Promise (resolve, reject) ->
					gulp.src src
						.pipe coffee opts
						.on 'error', (e) ->
							e.message += "\nFile: #{e.filename}"
							reject e
						.pipe gulp.dest dest
						.on 'end', ->
							resolve()
				promise.then ->
					log.msg 'compiled lib coffee files'

			cleanCoffee: ->
				del(glob.lib.coffee, DEL_OPTS).then (_paths) ->
					log.msg 'cleaned lib coffee files'

			minifyJs: ->
				src  = glob.lib.js
				dest = LIB
				opts = mangle: true
				promise = new Promise (resolve, reject) ->
					gulp.src src
						.pipe minifyJs opts
						.on 'error', (e) ->
							e.message += "\nFile: #{e.filename}"
							reject e
						.pipe gulp.dest dest
						.on 'end', ->
							resolve()
				promise.then ->
					log.msg 'minified lib js files'

			serverPkg:
				pack: ->
					pkg     = require "#{LIB_SERVER}/package.json"
					pkgName = "#{pkg.name}.tgz"
					src     = LIB_SERVER
					dest    = "#{LIB_SERVER}/#{pkgName}"
					tgzPkg  = fstream.Writer path: dest
					opts    =
						packer: noProprietary: true, fromBase: true
						reader: path: src, type: 'Directory'

					new Promise (resolve, reject) ->
						onError = (e) ->
							reject e

						onEnd = ->
							log.msg "created lib #{pkgName}"
							resolve()

						packer = tar.Pack opts.packer
									.on 'error', onError
									.on 'end', onEnd

						fstream.Reader opts.reader
							.on 'error', onError
							.pipe packer
							.pipe tgzPkg

		src:
			cleanup: ->
				src = ["#{SRC}/**/.DS_Store", "!#{SRC_NMS}/*/*"]
				del(src, DEL_OPTS).then (_paths) ->
					log.msg 'src cleanup'

			copy: ->
				fse.copyAsync(SRC, LIB).then ->
					log.msg 'copied src to lib'

			serverPkgs:
				exists: ->
					fse.statAsync(SRC_NMS).then ->
						log.msg 'src\'s server pkgs exist'

	# run tasks (in order, synchronously)
	# ===================================
	runTasks = async ->
		await tasks.src.serverPkgs.exists()
		await tasks.src.cleanup()
		await tasks.lib.clean()
		await tasks.src.copy()
		await tasks.lib.compileCoffee()
		await tasks.lib.cleanCoffee()
		await tasks.lib.minifyJs()
		await tasks.lib.serverPkg.pack()
		# success return
		message: 'lib created'

	# run it!
	# =======
	runTasks()




