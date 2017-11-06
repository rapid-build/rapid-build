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

# Regular Expressions
# ===================
Regx =
	htmlImports:
		/\bimport\s+(?:(.+)\s+from\s+)?[\'"`]([^`"\']+\.html)[`"\'](?=\n|\s?;|\s(?!\S))(\s*;)?/g

	htmlImport: (statement) ->
		# /import template from '..\/views\/rb-nav.html';/g
		new RegExp statement, 'g'

	templateVar: (variable) ->
		# /\btemplate(?=\n|\s?;|\s(?!\S))/g
		new RegExp "\\b#{variable}(?=\\n|\\s?;|\\s(?!\\S))", 'g'

# Html Imports
# { jsFilePath: { htmlFilePath: { statement:'', variable:'', html:'' }}}
# paths     = absolute
# statement = import template from '../views/rb-nav.html';
# variable  = template
# ======================================================================
HtmlImports = {}

# Compiler
# ========
CompileImports =
	get: (file, opts={}) -> # :string
		js = file.contents.toString()
		@_setHtmlImportVars file, js
		js = @_htmlImportReplace file, js
		js = @_templateVarReplace file, js
		js

	_setHtmlImportVars: (file, js) -> # :void
		jsPath      = file.path
		htmlImports = {}

		while (match = Regx.htmlImports.exec(js)) != null
			statement     = match[0]
			variable      = match[1]
			importPath    = match[2]
			importPathAbs = path.join file.dirname, importPath
			try
				html = fse.readFileSync importPathAbs, 'utf8'
			catch e
				e.message = "html import file in #{file.relative} doesn't exist: #{importPath}"
				console.error e.message.error
				continue
			htmlImport = { statement, variable, html }
			htmlImports[importPathAbs] = htmlImport

		hasImports = !!Object.getOwnPropertyNames(htmlImports).length
		return delete HtmlImports[jsPath] unless hasImports
		HtmlImports[jsPath] = {} unless HtmlImports[jsPath]
		HtmlImports[jsPath] = htmlImports

	_htmlImportReplace: (file, js) -> # :string
		return js unless HtmlImports[file.path]
		for importPath, htmlImport of HtmlImports[file.path]
			js = js.replace Regx.htmlImport(htmlImport.statement), ''
		js

	_templateVarReplace: (file, js) -> # :string
		return js unless HtmlImports[file.path]
		for importPath, htmlImport of HtmlImports[file.path]
			js = js.replace Regx.templateVar(htmlImport.variable), "`#{htmlImport.html}`"
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
			compiledJS    = CompileImports.get file, opts
			file.contents = new Buffer compiledJS
		catch e
			return cb new PluginError PLUGIN_NAME, e

		cb null, file

# Export It!
# ==========
module.exports = compileHtmlImports