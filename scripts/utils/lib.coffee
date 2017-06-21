# LIB HELPER
# ==========
fse      = require 'fs-extra'
del      = require 'del'
gulp     = require 'gulp'
coffee   = require 'gulp-coffee'
minifyJs = require 'gulp-uglify'
tar      = require 'tar'
fstream  = require 'fstream' # used in github tar examples
async    = require 'asyncawait/async'
await    = require 'asyncawait/await'
consts   = require '../consts/consts'
log      = require './log'

# module
# ======
module.exports =
	clean: async (verbose=false) -> # :promise<boolean>
		opts   = force: true
		_paths = await del consts.RB_LIB, opts
		log.msg _path, 'minor' for _path in _paths if verbose
		exists = await fse.pathExists consts.RB_LIB
		log.msg "cleaned lib: #{!exists}"
		exists

	copySrc: async -> # :promise<boolean>
		opts =
			errorOnExist: true
			filter: (src) -> not /\.DS_Store$/ig.test src
		copied = await fse.copy consts.RB_SRC, consts.RB_LIB, opts
		exists = await fse.pathExists consts.RB_LIB
		log.msg "copied src to lib: #{exists}"
		exists

	compileCoffee: -> # :promise<boolean>
		new Promise (resolve, reject) ->
			src  = ["#{consts.RB_LIB}/**/*.coffee", "!**/node_modules/**"]
			dest = consts.RB_LIB
			gulp.src src
				.pipe coffee bare: true
				.on 'error', (e) ->
					e.message += "\nFile: #{e.filename}"
					reject e
				.pipe gulp.dest dest
				.on 'end', ->
					log.msg "compiled coffee lib files: true"
					resolve true

	cleanCoffee: async (verbose=false) -> # :promise<boolean>
		opts   = force: true
		glob   = ["#{consts.RB_LIB}/**/*.coffee", "!**/node_modules/**"]
		_paths = await del glob, opts
		log.msg _path, 'minor' for _path in _paths if verbose
		exists = await fse.pathExists _paths[0]
		log.msg "cleaned coffee lib files: #{!exists and !!_paths.length}"
		exists

	cleanServer: async (verbose=false) -> # :promise<boolean> (for consumer installs)
		opts   = force: true
		glob   = ["#{consts.RB_LIB_SERVER}/*", "!#{consts.RB_LIB_SERVER_PKG}"]
		_paths = await del glob, opts
		log.msg _path, 'minor' for _path in _paths if verbose
		exists = await fse.pathExists consts.RB_LIB_SERVER_PKG
		log.msg "cleaned server lib: #{exists}"
		exists

	cleanupServer: async (verbose=false) -> # :promise<boolean> (for local installs)
		opts   = force: true
		glob   = ["#{consts.RB_LIB_SERVER}/package-lock.json"]
		_paths = await del glob, opts
		log.msg _path, 'minor' for _path in _paths if verbose
		exists = await fse.pathExists "#{consts.RB_LIB_SERVER}/package-lock.json"
		log.msg "cleaned up lib server: #{!exists}"
		exists

	minifyJs: -> # :promise<boolean>
		new Promise (resolve, reject) ->
			src  = ["#{consts.RB_LIB}/**/*.js", "!**/node_modules/**"]
			dest = consts.RB_LIB
			gulp.src src
				.pipe minifyJs mangle: true
				.on 'error', (e) ->
					e.message += "\nFile: #{e.filename}"
					reject e
				.pipe gulp.dest dest
				.on 'end', ->
					log.msg "minified js lib files: true"
					resolve true

	packServer: -> # :promise<boolean>
		new Promise (resolve, reject) ->
			src    = consts.RB_LIB_SERVER
			dest   = consts.RB_LIB_SERVER_PKG
			tgzPkg = fstream.Writer path: dest
			opts   =
				packer: noProprietary: true, fromBase: true
				reader: path: src, type: 'Directory'

			onError = (e) ->
				reject e

			onEnd = ->
				log.msg "packed lib server: #{consts.RB_LIB_SERVER_PKG_NAME}"
				resolve true

			packer =
				tar.Pack opts.packer
					.on 'error', onError
					.on 'end', onEnd

			fstream.Reader opts.reader
				.on 'error', onError
				.pipe packer
				.pipe tgzPkg

	unpackServer: -> # :promise<boolean>
		new Promise (resolve, reject) ->
			src  = consts.RB_LIB_SERVER_PKG
			dest = consts.RB_LIB_SERVER
			opts =
				extractor: path: dest
				reader: path: src, type: 'File'

			onError = (e) ->
				reject e

			onEnd = ->
				log.msg "unpacked #{consts.RB_LIB_SERVER_PKG_NAME}"
				resolve true

			extractor = tar.Extract opts.extractor
						.on 'error', onError
						.on 'end', onEnd

			fstream.Reader opts.reader
				.on 'error', onError
				.pipe extractor