module.exports = (config) ->
	path     = require 'path'
	log      = require "#{config.req.helpers}/log"
	pathHelp = require "#{config.req.helpers}/path"
	test     = require("#{config.req.helpers}/test")()

	# init internal
	# =============
	internal =
		rb:
			client:
				css:
					imports: {} # populated via task
		app:
			client:
				css:
					imports: {} # populated via task

	# methods
	# =======
	internal.deleteFileImports = (appOrRb, _path) ->
		key      = pathHelp.format _path
		imports  = @[appOrRb].client.css.imports
		return unless imports[key]
		delete imports[key]

	internal.getImports = (negated=false) ->
		rbImports  = @getImportsAppOrRb 'rb', negated
		appImports = @getImportsAppOrRb 'app', negated
		imports    = [].concat rbImports, appImports

	internal.getImportsAppOrRb = (appOrRb, negated=false) ->
		imports = @[appOrRb].client.css.imports
		return [] unless Object.keys(imports).length
		_imports = []
		negated  = if negated then '!' else ''
		for own k1, v1 of imports
			continue if not v1.length
			for v2 in v1
				_imports.push "#{negated}#{v2}"
		_imports

	# add internal to config
	# ======================
	config.internal = internal

	# logs
	# ====
	# log.json internal, 'internal ='

	# tests
	# =====
	test.log 'true', config.internal, 'add internal to config'

	# return
	# ======
	config