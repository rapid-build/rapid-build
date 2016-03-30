# CREATE PKG LIB
# ==============
module.exports = (rbRoot) ->
	gulp     = require 'gulp'
	coffee   = require 'gulp-coffee'
	async    = require 'asyncawait/async'
	await    = require 'asyncawait/await'
	Promise  = require 'bluebird'
	fse      = Promise.promisifyAll require 'fs-extra'

	SRC      = "#{rbRoot}/src"
	LIB      = "#{rbRoot}/lib" # lib is created from src
	LIB_GLOB = "#{LIB}/**/*.coffee"

	# tasks
	# =====
	cleanLib = ->
		fse.removeAsync LIB

	copySrc = ->
		fse.copyAsync SRC, LIB

	compileLibCoffee = ->
		src  = LIB_GLOB
		dest = LIB
		opts = bare: true
		new Promise (resolve, reject) ->
			gulp.src src
				.pipe coffee opts
				.on 'error', (e) ->
					e.message += "\nFile: #{e.filename}"
					reject e
				.pipe gulp.dest dest
				.on 'end', -> resolve()

	cleanLibCoffeeFiles = ->
		fse.removeAsync LIB_GLOB

	# run tasks (in order)
	# =========
	runTasks = async ->
		await cleanLib().then -> console.log 'lib cleaned'.info
		await copySrc().then -> console.log 'copied src to lib'.info
		await compileLibCoffee().then -> console.log 'compiled lib coffee files'.info
		await cleanLibCoffeeFiles().then -> console.log 'cleaned lib coffee files'.info

	# run it!
	# =======
	runTasks()



