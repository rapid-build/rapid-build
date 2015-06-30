module.exports = (config) ->
	fs   = require 'fs'
	path = require 'path'
	log  = require "#{config.req.helpers}/log"

	# helpers
	# =======
	getDirsRecursively = (_path, _dirs=[]) ->
		try
			filenames = fs.readdirSync _path
		catch e
			console.log e.message.error
			return _dirs
		return _dirs if not filenames.length
		for filePath in filenames
			newPath = path.join _path, filePath
			continue if not fs.statSync(newPath).isDirectory()
			_dirs.push newPath
			getDirsRecursively newPath, _dirs
		_dirs

	filter = (dirs, filterPaths) ->
		_dirs = []
		for _path in dirs
			flag = false
			for fPath in filterPaths
				if _path.indexOf(fPath) isnt -1 then flag = true; break
			_dirs.push _path if not flag
		_dirs

	# API
	# ===
	filter:
		dirs: filter

	get:
		dirs: (initPath, filterPaths=[], reverse) ->
			dirs = getDirsRecursively initPath
			dirs = filter dirs, filterPaths if filterPaths.length
			dirs.reverse() if reverse is 'reverse'
			# log.json dirs
			dirs

		emptyDirs: (initPath, filterPaths=[], reverse) ->
			dirs = @dirs initPath, filterPaths, reverse
			return dirs if not dirs.length
			_dirs    = []
			fileDirs = {}

			for _path in dirs
				filenames = fs.readdirSync _path
				for filePath, i in filenames
					newPath = path.join _path, filePath
					continue if not fs.statSync(newPath).isFile()
					fileDirs[_path] = i + 1 # total files

			return dirs if not Object.keys(fileDirs).length

			for _path in dirs
				flag = false
				for own k, v of fileDirs
					if k.indexOf(_path) isnt -1 then flag = true; break
				_dirs.push _path if not flag

			_dirs






