# CREATE PKG LIB
# ==============
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
					console.log 'lib cleaned'.info

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
					console.log 'compiled lib coffee files'.info

			cleanCoffee: ->
				del(glob.lib.coffee, DEL_OPTS).then (_paths) ->
					console.log 'cleaned lib coffee files'.info

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
					console.log 'minified lib js files'.info

			serverPks:
				pack: ->
					pkg     = require "#{LIB_SERVER}/package.json"
					pkgName = "#{pkg.name}-pkgs.tgz"
					src     = LIB_NMS
					dest    = "#{LIB_SERVER}/#{pkgName}"
					tgzPkg  = fse.createWriteStream dest

					new Promise (resolve, reject) ->
						onError = (e) ->
							reject e

						onEnd = ->
							console.log "packed #{pkgName}".info
							resolve()

						packer = tar.Pack noProprietary: true
									.on 'error', onError
									.on 'end', onEnd

						fstream.Reader path: src, type: 'Directory'
							.on 'error', onError
							.pipe packer
							.pipe tgzPkg

		src:
			copy: ->
				src = ["#{SRC}/**"] # , "!#{SRC_NMS}/**"
				promise = new Promise (resolve, reject) ->
					gulp.src src
						.pipe gulp.dest LIB
						.on 'end', ->
							resolve()
				promise.then ->
					console.log 'copied src to lib'.info

	# run tasks (in order, synchronously)
	# ===================================
	runTasks = async ->
		await tasks.lib.clean()
		await tasks.src.copy()
		await tasks.lib.compileCoffee()
		await tasks.lib.cleanCoffee()
		await tasks.lib.minifyJs()
		await tasks.lib.serverPks.pack()

	# run it!
	# =======
	runTasks()



