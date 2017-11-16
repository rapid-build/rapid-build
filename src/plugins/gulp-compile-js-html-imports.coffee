# GULP PLUGIN: gulp-compile-js-html-imports
# Plugin level: function(dealing with files)
# Compiles html imports inside scripts.
# Currently no opts available.
# ==========================================
through     = require 'through2'
gulp        = require 'gulp'
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
		props = event: null, base: null, relative: null, extname: null, stem: null, basename: null, cwd: null, dirname: null, path: null, event: null
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

	isHtmlFile: (val) ->
		return false if typeof val isnt 'string'
		val.toLowerCase().indexOf('.html') isnt -1

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
# 	contents: ''          (the uninlined js file contents)
# ======================================================================
HtmlImports = {}

# COMPILER
# ========
InlineImports =
	# Public Methods
	# ==============
	get: (file, opts={}) -> # :@JS (run in order)
		# Help.inspectFile file
		if Help.isHtmlFile file.extname
			@reloadJS file
			return hasImports: false
		@initJS file
		@setHtmlImportVars()
		@updateJS hasImports: @hasImports()
		# Help.logJson @JS
		return @JS unless @JS.hasImports
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
			hasImports: false                    # does js contents have html import(s)
			dir:        path.dirname _path       # dist/client/scripts
			path:       _path                    # dist/client/scripts/xxx.js
			relPath:    file.relative            # scripts/xxx.js
			extname:    file.extname             # .js
			contents:   file.contents.toString() # original uninlined js contents (needed for html watch)

	updateJS: (props={}) -> # :void
		return unless Help.isEmptyObject props
		for key, val of props
			continue if typeof @JS[key] is 'undefined'
			@JS[key] = val

	hasImports: -> # :boolean
		!!HtmlImports[@JS.path] and !!HtmlImports[@JS.path].hasImports

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
		if HtmlImports[@JS.path] and HtmlImports[@JS.path].hasImports
			return HtmlImports[@JS.path].hasImports = hasImports

		return delete HtmlImports[@JS.path] unless hasImports
		HtmlImports[@JS.path] = { imports: htmlImports, hasImports, contents: @JS.contents }

	reloadJS: (file) -> # :void (for watching html files)
		# Help.logJson HtmlImports
		htmlPath = path.join file.base, file.relative
		jsFiles  = []
		for jsPath, jsFile of HtmlImports
			continue unless jsFile.imports[htmlPath]
			jsFiles.push jsPath
		return unless jsFiles.length
		# Help.logJson HtmlImports
		for jsPath in jsFiles
			fse.pathExists(jsPath).then (exists) ->
				unless exists
					eMsg = "failed to inline html import, file doesn't exist: #{jsPath}"
					return console.error eMsg.error
				fse.outputFile(jsPath, HtmlImports[jsPath].contents).then ->
					delete HtmlImports[jsPath]

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
			return cb null unless inlinedJS.hasImports
			file.contents = new Buffer inlinedJS.contents
		catch e
			return cb new PluginError PLUGIN_NAME, e

		cb null, file

# EXPORT IT!
# ==========
module.exports = inlineJsHtmlImports