# LIB HELPER
# ==========
q        = require 'q'
fse      = require 'fs-extra'
del      = require 'del'
gulp     = require 'gulp'
coffee   = require 'gulp-coffee'
minifyJs = require 'gulp-uglify'
tar      = require 'tar'
fstream  = require 'fstream' # used in github tar examples
consts   = require '../consts/consts'
log      = require './log'

# module
# ======
module.exports =
	clean: (verbose=false) -> # :promise<boolean>
		defer = q.defer()
		tasks = [
			->
				del(consts.RB_LIB, force: true).then (_paths) ->
					log.msg _path, 'minor' for _path in _paths if verbose
			->
				fse.pathExists(consts.RB_LIB).then (exists) ->
					exists = !exists
					log.msg "cleaned lib: #{exists}"
					exists
		]
		tasks.reduce(q.when, q()).done (val) -> defer.resolve val
		defer.promise

	copySrc: -> # :promise<boolean>
		defer = q.defer()
		tasks = [
			->
				opts =
					errorOnExist: true
					filter: (src) -> not /\.DS_Store$/ig.test src
				fse.copy consts.RB_SRC, consts.RB_LIB, opts
			->
				fse.pathExists(consts.RB_LIB).then (exists) ->
					log.msg "copied src to lib: #{exists}"
					exists
		]
		tasks.reduce(q.when, q()).done (val) -> defer.resolve val
		defer.promise

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

	cleanCoffee: (verbose=false) -> # :promise<boolean>
		defer = q.defer()
		tasks = [
			->
				glob = ["#{consts.RB_LIB}/**/*.coffee", "!**/node_modules/**"]
				del(glob, force: true).then (_paths) ->
					log.msg _path, 'minor' for _path in _paths if verbose
					_paths
			(_paths) -> # coffee file paths
				fse.pathExists(_paths[0]).then (exists) ->
					exists = !exists and !!_paths.length
					log.msg "cleaned coffee lib files: #{exists}"
					exists
		]
		tasks.reduce(q.when, q()).done (val) -> defer.resolve val
		defer.promise

	cleanServer: (verbose=false) -> # :promise<boolean> (for consumer installs)
		defer = q.defer()
		tasks = [
			->
				glob = ["#{consts.RB_LIB_SERVER}/*", "!#{consts.RB_LIB_SERVER_PKG}"]
				del(glob, force: true).then (_paths) ->
					log.msg _path, 'minor' for _path in _paths if verbose
			->
				fse.pathExists(consts.RB_LIB_SERVER_PKG).then (exists) ->
					log.msg "cleaned server lib: #{exists}"
					exists
		]
		tasks.reduce(q.when, q()).done (val) -> defer.resolve val
		defer.promise

	cleanupServer: (verbose=false) -> # :promise<boolean> (for local installs)
		defer = q.defer()
		tasks = [
			->
				glob = ["#{consts.RB_LIB_SERVER}/package-lock.json"]
				del(glob, force: true).then (_paths) ->
					log.msg _path, 'minor' for _path in _paths if verbose
			->
				fse.pathExists("#{consts.RB_LIB_SERVER}/package-lock.json").then (exists) ->
					exists = !exists
					log.msg "cleaned up lib server: #{exists}"
					exists
		]
		tasks.reduce(q.when, q()).done (val) -> defer.resolve val
		defer.promise

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