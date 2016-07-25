# Cleans dirs in the build's generated directory.
# config.build.cli.opts.cacheClean:
#   true (clean app's cache)
#   *    (clean all app's cache)
# ===============================================
module.exports = (config) ->
	cacheClean = config.build.cli.opts.cacheClean
	return unless cacheClean

	# requires
	# ========
	del  = require 'del'
	fs   = require 'fs'
	fse  = require 'fs-extra'
	path = require 'path'

	# helpers (gen = generated)
	# =========================
	addGenPathToDirs = (dirs, _path) ->
		return [] if not dirs or not dirs.length
		dirs = (path.join _path, dir for dir in dirs)

	getGenDirs = (_path) ->
		try
			dirs = fs.readdirSync(_path).filter (file) ->
				fs.statSync(path.join(_path, file)).isDirectory()
			dirs = addGenPathToDirs dirs, _path
		catch e

	getGenDir = (_path) ->
		appPkg = require path.join config.app.path, 'package.json'
		path.join _path, appPkg.name

	# vars
	# ====
	genPath   = config.build.generated.path
	cleanAll  = cacheClean is '*'
	cleanDirs = if cleanAll then getGenDirs genPath else getGenDir genPath

	# task
	# ====
	cleanTask = (dirs) ->
		promise = del dirs, force: true
		promise.then (paths) ->
			msg = if cleanAll then 'all apps' else 'app'
			msg = "Cleaned #{config.build.pkg.name}'s internal cache for #{msg}."
			console.log msg.attn
		promise

	# return
	# ======
	cleanTask cleanDirs
