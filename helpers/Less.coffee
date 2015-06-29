module.exports = (config, gulp) ->
	q           = require 'q'
	lessImports = require 'less-imports'
	log         = require "#{config.req.helpers}/log"

	class Less
		# private methods
		# ===============
		getImports = (files) ->
			imports = {}
			for own k1, v1 of files
				continue if not v1.length
				v1.forEach (v2, i) ->
					imports[v2] = i
			Object.keys imports

		addNotToImports = (imports) ->
			imports.forEach (v, i) ->
				imports[i] = "!#{v}"
			imports

		isImport = (imports, _path) ->
			imports.indexOf(_path) isnt -1

		# constructor
		# ===========
		constructor: (@src) ->
			@imports = {}
			@files   = {}

		# public methods
		# ==============
		addImport: (_path) ->
			paths = lessImports.findImports _path
			return @ if not paths.length
			@files[_path] = paths
			@

		setImports: ->
			defer = q.defer()
			gulp.src @src, read:false
				.on 'data', (file) =>
					@addImport file.path
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
			return [ _path ] if not isImport imports, _path
			# is import, what non import(s) has it?
			src = []
			for own k1, v1 of files
				continue if isImport imports, k1
				continue if v1.indexOf(_path) is -1 # file has import
				src.push k1
			src



