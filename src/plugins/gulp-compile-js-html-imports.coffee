# GULP PLUGIN: gulp-compile-js-html-imports
# Plugin level: function(dealing with files)
# Compiles html imports inside scripts.
# Currently no opts available.
# ==========================================
through     = require 'through2'
gutil       = require 'gulp-util'
path        = require 'path'
fse         = require 'fs-extra'
PLUGIN_NAME = 'gulp-compile-js-html-imports'
PluginError = gutil.PluginError

# Helpers
# =======
Help =
	logJson: (json) ->
		console.log JSON.stringify json, null, '\t'

	inspectFile: (file, sort=false) -> # log Vinyl props
		props = base: null, relative: null, extname: null, stem: null, basename: null, cwd: null, dirname: null, path: null
		if sort then Object.keys(props).sort().forEach (key) -> delete props[key]; props[key] = null
		for key of props then props[key] = file[key]
		json = JSON.stringify(props, null, '\t').replace(/"/g, "'").replace /(\t)'(\w*)'/g, '$1$2'
		console.log json

# Regular Expressions
# ===================
Regx =
	htmlImports:
		# TODO
		# • exclude imports in comments
		# • fix multiple imports on the same line
		/\bimport\s+(?:(.+)\s+from\s+)?[\'"`]([^`"\']+\.html)[`"\'](?=\n|\s?;|\s(?!\S))(\s*;)?/g

	htmlImport: (statement) ->
		# /import template from '..\/views\/rb-nav.html';\n?/g
		new RegExp "#{statement}\\n?", 'g'

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
	js:
		dir:  null # dist/client/scripts
		path: null # dist/client/scripts/xxx.js

	get: (file, opts={}) -> # :string
		js      = file.contents.toString()
		@jsPath = path.join file.base, file.relative
		@_setJsPathInfo file
		@_setHtmlImportVars file, js
		js = @_htmlImportReplace js
		js = @_templateVarReplace js
		# Help.inspectFile file
		# Help.logJson @js
		# Help.logJson HtmlImports
		js

	_setJsPathInfo: (file) -> # :void
		@js.path = path.join file.base, file.relative
		@js.dir  = path.dirname @js.path

	_setHtmlImportVars: (file, js) -> # :void
		htmlImports = {}

		while (match = Regx.htmlImports.exec(js)) != null
			statement     = match[0]
			variable      = match[1]
			importPath    = match[2] # ../views/xxx.html
			importPathRel = path.join @js.dir, importPath # dist/client/views/xxx.html
			try
				html = fse.readFileSync importPathRel, 'utf8'
			catch e
				e.message = "html import file in #{file.relative} doesn't exist: #{importPath}"
				console.error e.message.error
				continue
			htmlImport = { statement, variable, html }
			htmlImports[importPathRel] = htmlImport

		hasImports = !!Object.getOwnPropertyNames(htmlImports).length
		return delete HtmlImports[@js.path] unless hasImports
		HtmlImports[@js.path] = {} unless HtmlImports[@js.path]
		HtmlImports[@js.path] = htmlImports

	_htmlImportReplace: (js) -> # :string
		return js unless HtmlImports[@js.path]
		for importPath, htmlImport of HtmlImports[@js.path]
			js = js.replace Regx.htmlImport(htmlImport.statement), ''
		js

	_templateVarReplace: (js) -> # :string
		return js unless HtmlImports[@js.path]
		for importPath, htmlImport of HtmlImports[@js.path]
			js = js.replace Regx.templateVar(htmlImport.variable), "`#{htmlImport.html}`"
			js
		js

# Gulp Plugin
# ===========
compileJsHtmlImports = (opts={}) ->
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
module.exports = compileJsHtmlImports