module.exports = (config, gulp) ->
	q          = require 'q'
	path       = require 'path'
	log        = require "#{config.req.helpers}/log"
	pathHelp   = require "#{config.req.helpers}/path"
	cmtsRegex  = /\/\/.*|\/\*\s*?.*?\s*?\*\//g
	importRegX = /@import\s*?(?!\s*?\(css\)*?).*?['"]+?(.*?)['"]/g

	class Sass
		# private methods
		# ===============
		getImports = (files) ->
			imports = {}
			for own k1, v1 of files
				continue unless v1.length
				v1.forEach (v2, i) ->
					imports[v2] = i
			Object.keys imports

		addNotToImports = (imports) ->
			imports.forEach (v, i) ->
				imports[i] = "!#{v}"
			imports

		isImport = (imports, _path) ->
			flag  = false
			return flag unless imports.length
			_path = getExtlessPath _path
			for _import in imports
				if _import.indexOf(_path) isnt -1 then flag = true; break
			flag

		fileHasImport = (imports, _path) ->
			isImport imports, _path

		getExtlessPath = (_path) -> # because of '.{sass,scss}'
			lastIndex = _path.lastIndexOf('.') + 1
			_path     = _path.substr 0, lastIndex

		findImports = (file) ->
			contents = file.contents
			return [] unless contents
			contents = contents.toString()
			dir      = path.dirname file.path
			cssExt   = '.css'
			sassExts = '.{sass,scss}'
			imports  = []
			contents = contents.replace cmtsRegex, '' # first strip the comments
			while (matches = importRegX.exec contents) != null
				match  = matches[1]
				continue if match.indexOf('//') isnt -1
				continue if matches[0].indexOf('url(') isnt -1
				_path  = path.resolve dir, match
				impDir = path.extname _path
				continue if impDir is cssExt
				_path += sassExts unless impDir
				_path  = pathHelp.format _path
				imports.push _path
			imports

		# constructor
		# ===========
		constructor: (@src) ->
			@imports = {}
			@files   = {}

		# public methods
		# ==============
		addImport: (file) ->
			paths = findImports file
			return @ unless paths.length
			@files[file.path] = paths
			@

		setImports: ->
			defer = q.defer()
			gulp.src @src
				.on 'error', (e) -> defer.reject e
				.on 'data', (file) =>
					@addImport file
				.on 'end', =>
					defer.resolve @
			defer.promise

		getFiles: ->
			@files

		getImports: ->
			files    = @getFiles()
			imports  = getImports files
			@imports = addNotToImports imports
			@imports

		getWatchSrc: (_path) ->
			_path   = pathHelp.format _path
			files   = @getFiles()
			imports = getImports files
			return [ _path ] unless isImport imports, _path
			# is import, what non import(s) has it?
			src = []
			for own _file, fileImports of files
				continue if isImport imports, _file
				continue unless fileHasImport fileImports, _path
				src.push _file
			src




