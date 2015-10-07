module.exports = (config, gulp) ->
	q          = require 'q'
	path       = require 'path'
	log        = require "#{config.req.helpers}/log"
	pathHelp   = require "#{config.req.helpers}/path"
	cmtsRegex  = /\/\/.*|\/\*\s*?.*?\s*?\*\//g
	importRegX = /@import\s*?(?!\s*?\(css\)*?).*?['"]+?(.*?)['"]/g

	class Less
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
			imports.indexOf(_path) isnt -1

		findImports = (file) ->
			contents = file.contents
			return [] unless contents
			contents = contents.toString()
			dir      = path.dirname file.path
			lessExt  = '.less'
			imports  = []
			contents = contents.replace cmtsRegex, '' # first strip the comments
			while (matches = importRegX.exec contents) != null
				match  = matches[1]
				continue if match.indexOf('//') isnt -1
				_path  = path.resolve dir, match
				impDir = path.extname _path
				_path += lessExt unless impDir
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
			files   = @getFiles()
			imports = getImports files
			return [ _path ] unless isImport imports, _path
			# is import, what non import(s) has it?
			src = []
			for own k1, v1 of files
				continue if isImport imports, k1
				continue if v1.indexOf(_path) is -1 # file has import
				src.push k1
			src




