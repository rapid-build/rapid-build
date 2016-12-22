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
	fse      = Promise.promisifyAll require 'fs-extra'

	SRC      = "#{rbRoot}/src"
	LIB      = "#{rbRoot}/lib" # lib is created from src
	LIB_NMS  = "#{LIB}/src/server/node_modules"
	DEL_OPTS = force: true
	glob =
		lib:
			js:     ["#{LIB}/**/*.js",     "!#{LIB_NMS}/**"]
			coffee: ["#{LIB}/**/*.coffee", "!#{LIB_NMS}/**"]

	# tasks
	# =====
	tasks =
		cleanLib: ->
			del(LIB, DEL_OPTS).then (_paths) ->
				console.log 'lib cleaned'.info

		copySrc: ->
			fse.copyAsync(SRC, LIB).then ->
				console.log 'copied src to lib'.info

		compileLibCoffee: ->
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

		cleanLibCoffeeFiles: ->
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

	# run tasks (in order)
	# ====================
	runTasks = async ->
		await tasks.cleanLib()
		await tasks.copySrc()
		await tasks.compileLibCoffee()
		await tasks.cleanLibCoffeeFiles()
		await tasks.minifyJs()

	# run it!
	# =======
	runTasks()



