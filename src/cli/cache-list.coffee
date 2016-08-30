# List the build's cache dirs in generated directory.
# ===================================================
module.exports = (config) ->
	cacheList = config.build.cli.opts.cacheList
	return unless cacheList

	# requires
	# ========
	fs   = require 'fs'
	path = require 'path'

	# helpers (gen = generated)
	# =========================
	addGenPathToDirs = (dirs, _path) -> # []
		return [] if not dirs or not dirs.length
		dirs = (path.join _path, dir for dir in dirs)

	getCacheInfo = (_path) -> # {}
		cache = dirs: [], paths: []
		try
			dirs = fs.readdirSync(_path).filter (file) ->
				fs.statSync(path.join(_path, file)).isDirectory()
			cache.dirs  = dirs
			cache.paths = addGenPathToDirs dirs, _path
		catch e
		cache

	# vars
	# ====
	genPath   = config.build.generated.path
	cacheInfo = getCacheInfo genPath

	# task
	# ====
	logCacheTask = (dirsOrPaths) -> # void
		if not dirsOrPaths or not dirsOrPaths.length
			msg = "#{config.build.pkg.name}'s cache is clean"
			return console.log msg.attn

		for val, i in dirsOrPaths
			console.log "#{i+1}) #{val}".attn

	# return
	# ======
	logCacheTask cacheInfo.dirs
