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
require('colors').setTheme error:['red','bold'] unless 'colors'.error

# HELPERS
# =======
Help =
	inspectFile: (file, sort=false) -> # log vinyl props
		props = base: null, relative: null, extname: null, stem: null, basename: null, cwd: null, dirname: null, path: null, event: null
		if sort then Object.keys(props).sort().forEach (key) -> delete props[key]; props[key] = null
		for key of props then props[key] = file[key]
		json = JSON.stringify(props, null, '\t').replace(/"/g, "'").replace /(\t)'(\w*)'/g, '$1$2'
		console.log json

	logJson: (json) -> # log pretty json
		console.log JSON.stringify json, null, '\t'

	isObject: (val) ->
		return false if typeof val isnt 'object'
		return false if val is null
		return false if Array.isArray val
		true

	isEmptyObject: (obj) -> # :boolean
		return false unless @isObject obj
		!!Object.getOwnPropertyNames(obj).length

# REGULAR EXPRESSIONS
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

# HTML IMPORTS (hashmap)
# jsPath:                 (dist/client/scripts/xxx.js)
# 	imports:
# 		htmlPath:         (dist/client/views/xxx.html)
# 			statement: '' (import template from '../views/xxx.html';)
# 			variable: ''  (template)
# 			html: ''      (html file contents)
# ======================================================================
HtmlImports = {}

# COMPILER
# ========
InlineImports =
	# Public Methods
	# ==============
	get: (file, opts={}) -> # :@JS (run in order)
		@initJS file
		@setHtmlImportVars()
		@updateJS changed: @didFileChange()
		# console.log 'CHANGED:', @JS.changed
		return @JS unless @JS.changed
		@htmlImportReplace()
		@templateVarReplace()
		# Help.logJson @JS
		# Help.logJson HtmlImports
		@JS

	# Private Methods
	# ===============
	initJS: (file) -> # :void (@JS will be the return value for @get())
		_path = path.join file.base, file.relative
		@JS =
			changed:  false                    # changed if js contents has html import(s)
			dir:      path.dirname _path       # dist/client/scripts
			path:     _path                    # dist/client/scripts/xxx.js
			relPath:  file.relative            # scripts/xxx.js
			contents: file.contents.toString() # original uninlined js contents (needed for html watch)

	updateJS: (props={}) -> # :void
		return unless Help.isEmptyObject props
		for key, val of props
			continue if typeof @JS[key] is 'undefined'
			@JS[key] = val

	didFileChange: -> # :boolean
		!!HtmlImports[@JS.path]

	setHtmlImportVars: -> # :void
		htmlImports = {}
		while (match = Regx.htmlImports.exec(@JS.contents)) != null
			statement      = match[0] # import template from '../views/xxx.html';
			variable       = match[1] # template
			importPath     = match[2] # ../views/xxx.html
			importDistPath = path.join @JS.dir, importPath # dist/client/views/xxx.html
			try
				html = fse.readFileSync importDistPath, 'utf8'
			catch e
				e.message = "html import file in #{@JS.relPath} doesn't exist: #{importPath}"
				console.error e.message.error
				continue
			htmlImport = { statement, variable, html }
			htmlImports[importDistPath] = htmlImport

		hasImports = Help.isEmptyObject htmlImports
		return delete HtmlImports[@JS.path] unless hasImports
		HtmlImports[@JS.path] = {} unless HtmlImports[@JS.path]
		HtmlImports[@JS.path].imports = htmlImports

	htmlImportReplace: -> # :void
		return unless !!HtmlImports[@JS.path]
		for htmlPath, htmlImport of HtmlImports[@JS.path].imports
			@JS.contents = @JS.contents.replace Regx.htmlImport(htmlImport.statement), ''

	templateVarReplace: -> # :void
		return unless !!HtmlImports[@JS.path]
		for htmlPath, htmlImport of HtmlImports[@JS.path].imports
			@JS.contents = @JS.contents.replace Regx.templateVar(htmlImport.variable), "`#{htmlImport.html}`"

# GULP PLUGIN
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

# EXPORT IT!
# ==========
module.exports = inlineJsHtmlImports