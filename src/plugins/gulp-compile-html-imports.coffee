# GULP PLUGIN: gulp-compile-html-imports
# Plugin level: function(dealing with files)
# Compiles html imports inside scripts.
# Currently no opts available.
# ==========================================
through     = require 'through2'
gutil       = require 'gulp-util'
path        = require 'path'
fse         = require 'fs-extra'
PLUGIN_NAME = 'gulp-compile-html-imports'
PluginError = gutil.PluginError

# Compiler
# ========
compileImports =
	opts: {}

	htmlImports: [] # :[{}] -> { statement: '', variable: '', path: '', html: '' }

	get: (file, opts) -> # :string
		@_setOpts file, opts
		js = file.contents.toString()
		@_setHtmlImportVars file, js
		js = @_htmlImportReplace js
		js = @_templateVarReplace js
		js

	_setOpts: (file, opts={}) -> # :void
		Object.assign @opts, opts

	_setHtmlImportVars: (file, js) -> # :void
		regx = /\bimport\s+(?:(.+)\s+from\s+)?[\'"`]([^`"\']+\.html)[`"\'](?=\n|\s?;|\s(?!\S))(\s*;)?/g
		while (match = regx.exec(js)) != null
			htmlImport =
				statement: match[0]
				variable:  match[1]
				path:      path.join file.dirname, match[2]
			htmlImport.html = fse.readFileSync htmlImport.path, 'utf8'
			@htmlImports.push htmlImport

	_htmlImportReplace: (js) -> # :string
		return js unless @htmlImports.length
		for htmlImport, i in @htmlImports
			regx = new RegExp "#{htmlImport.statement}", 'g'
			js = js.replace regx, ''
		js

	_templateVarReplace: (js) -> # :string
		return js unless @htmlImports.length
		for htmlImport, i in @htmlImports
			# \btemplate(?=\n|\s?;|\s(?!\S))
			regx = new RegExp "\\b#{htmlImport.variable}(?=\\n|\\s?;|\\s(?!\\S))", 'g'
			js = js.replace regx, "`#{htmlImport.html}`"
			js
		js

# Gulp Plugin
# ===========
compileHtmlImports = (opts={}) ->
	through.obj (file, enc, cb) ->
		return cb null, file unless file
		return cb null, file if file.isNull()
		return cb new PluginError PLUGIN_NAME, 'streaming not supported' if file.isStream()
		return cb null, file unless file.isBuffer()
		try
			compiledJS    = compileImports.get file, opts
			file.contents = new Buffer compiledJS
		catch e
			return cb new PluginError PLUGIN_NAME, e

		cb null, file

# Export It!
# ==========
module.exports = compileHtmlImports