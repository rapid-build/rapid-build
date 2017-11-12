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
	logJson: (json) -> # log pretty json
		console.log JSON.stringify json, null, '\t'

	inspectFile: (file, sort=false) -> # log vinyl props
		props = base: null, relative: null, extname: null, stem: null, basename: null, cwd: null, dirname: null, path: null, event: null
		if sort then Object.keys(props).sort().forEach (key) -> delete props[key]; props[key] = null
		for key of props then props[key] = file[key]
		json = JSON.stringify(props, null, '\t').replace(/"/g, "'").replace /(\t)'(\w*)'/g, '$1$2'
		console.log json

	isEmptyObject: (obj) -> # :boolean
		return false unless typeof obj is 'object'
		!!Object.getOwnPropertyNames(obj).length

	hasImports: (obj) -> # :boolean (obj = js file object in HtmlImports)
		return false unless typeof obj is 'object'
		@isEmptyObject obj['imports']


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
# jsPath:
# 	imports:
# 		htmlPath:
# 			statement: ''
# 			variable: ''
# 			html: ''
# 	contents:
# 		uncompiled: ''
# 		compiled: ''
# paths     = absolute
# statement = import template from '../views/rb-nav.html';
# variable  = template
# ======================================================================
HtmlImports = {}

# Compiler
# ========
InlineImports =
	js:
		changed:  false # (boolean) is file.contents same as HtmlImports.jsPath.compiledJS
		dir:      null  # dist/client/scripts
		path:     null  # dist/client/scripts/xxx.js
		relPath:  null  # scripts/xxx.js
		contents: null  # original uncompiled js contents, needed for html watch

	get: (file, opts={}) -> # :@js (run in order)
		@_setJsProps file
		@_setHtmlImportVars()
		@_setJsChanged()
		return @js unless @js.changed
		js = @_htmlImportReplace @js.contents
		js = @_templateVarReplace js
		@_setHtmlImportContents js
		@js.contents = js
		# console.log js
		# Help.inspectFile file
		# Help.logJson @js
		# Help.logJson HtmlImports
		# Help.logJson returnVal
		@js

	_setJsProps: (file) -> # :void (run in order)
		@js.relPath  = file.relative
		@js.path     = path.join file.base, @js.relPath
		@js.dir      = path.dirname @js.path
		@js.contents = file.contents.toString()

	_setJsChanged: -> # :void
		@js.changed = @_didFileChange()

	_didFileChange: -> # :boolean
		return false unless HtmlImports[@js.path]
		@js.contents isnt HtmlImports[@js.path].contents.compiled

	_setHtmlImportVars: -> # :void
		htmlImports = {}
		while (match = Regx.htmlImports.exec(@js.contents)) != null
			statement      = match[0] # import template from '../views/xxx.html';
			variable       = match[1] # template
			importPath     = match[2] # ../views/xxx.html
			importDistPath = path.join @js.dir, importPath # dist/client/views/xxx.html
			try
				html = fse.readFileSync importDistPath, 'utf8'
			catch e
				e.message = "html import file in #{@js.relPath} doesn't exist: #{importPath}"
				console.error e.message.error
				continue
			htmlImport = { statement, variable, html }
			htmlImports[importDistPath] = htmlImport

		hasImports = Help.isEmptyObject htmlImports
		return delete HtmlImports[@js.path] unless hasImports
		HtmlImports[@js.path] = {} unless HtmlImports[@js.path]
		# Object.assign HtmlImports[@js.path], htmlImports
		HtmlImports[@js.path].imports  = htmlImports
		HtmlImports[@js.path].contents = {}

	_setHtmlImportContents: (js) -> # :void
		return js unless Help.hasImports HtmlImports[@js.path]
		contents = uncompiled: @js.contents, compiled: js
		HtmlImports[@js.path].contents = contents

	_htmlImportReplace: (js) -> # :string | null
		return js unless Help.hasImports HtmlImports[@js.path]
		for htmlPath, htmlImport of HtmlImports[@js.path].imports
			js = js.replace Regx.htmlImport(htmlImport.statement), ''
		js

	_templateVarReplace: (js) -> # :string
		return js unless Help.hasImports HtmlImports[@js.path]
		for htmlPath, htmlImport of HtmlImports[@js.path].imports
			js = js.replace Regx.templateVar(htmlImport.variable), "`#{htmlImport.html}`"
			js
		js

# Gulp Plugin
# ===========
inlineJsHtmlImports = (opts={}) ->
	through.obj (file, enc, cb) ->
		return cb null, file unless file
		return cb null, file if file.isNull()
		return cb new PluginError PLUGIN_NAME, 'streaming not supported' if file.isStream()
		return cb null, file unless file.isBuffer()
		try
			inlinedJS = InlineImports.get file, opts
			return cb null unless inlinedJS.changed
			file.contents = new Buffer inlinedJS.contents
		catch e
			return cb new PluginError PLUGIN_NAME, e

		cb null, file

# Export It!
# ==========
module.exports = inlineJsHtmlImports