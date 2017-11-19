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

# CONSTANTS
# =========
COMMENT_PLACEHOLDER = '//RB_COMMENT_PLACEHOLDER'

# HELPERS
# =======
Help =
	getKeyPath: (file) -> # :string | void
		return unless file
		path.join file.base, file.relative

	inspectFile: (file, sort=false) -> # :void (log vinyl props)
		props = event: null, base: null, relative: null, extname: null, stem: null, basename: null, cwd: null, dirname: null, path: null, event: null
		if sort then Object.keys(props).sort().forEach (key) -> delete props[key]; props[key] = null
		for key of props then props[key] = file[key]
		json = JSON.stringify(props, null, '\t').replace(/"/g, "'").replace /(\t)'(\w*)'/g, '$1$2'
		console.log json

	isObject: (val) -> # :boolean
		return false if typeof val isnt 'object'
		return false if val is null
		return false if Array.isArray val
		true

	isEmptyObject: (obj) -> # :boolean
		return false unless @isObject obj
		!Object.getOwnPropertyNames(obj).length

	isHtmlFile: (file) -> # :boolean
		return false unless file
		return false if typeof file.extname isnt 'string'
		file.extname.toLowerCase().indexOf('.html') isnt -1

	logJson: (json) -> # :void (log pretty json)
		console.log JSON.stringify json, null, '\t'

# REGULAR EXPRESSIONS
# ===================
Regx =
	comments:
		/\/\*[\s\S]*?\*\/|([^\\:]|^)\/\/.*$/gm

	htmlImports:
		/\bimport\s+(?:(.+?)\s+from\s+)?[\'"`]([^`"\']+\.html)[`"\'](?=\s*?(;|\/\/|\/\*|\n|$))(\s*;)?/g

	htmlImport: (statement) -> # :RegExp
		# /import template from '..\/views\/rb-nav.html';\n?/g
		new RegExp "#{statement}\\n?", 'g'

	templateVar: (variable) -> # :RegExp
		# \btemplate(?=\s*?(;|\/\/|\/\*|\n|$))(?!\s+?(:|\(|from))
		new RegExp "\\b#{variable}(?=\\s*?(;|\\/\\/|\\/\\*|\\n|$))(?!\\s+?(:|\\(|from))", 'g'

# HTML IMPORTS (hashmap)
# jsPath:                 (dist/client/scripts/xxx.js)
# 	imports:
# 		htmlPath:         (dist/client/views/xxx.html)
# 			statement: '' (import template from '../views/xxx.html';)
# 			variable: ''  (template)
# 			html: ''      (html file contents)
# 	contents:
# 		compiled: ''      (the inlined js file contents)
# 		uncompiled: ''    (the uninlined js file contents)
# ======================================================================
HtmlImports = {}

# COMPILER
# ========
InlineImports =
	# Public Methods
	# ==============
	get: (file, opts={}) -> # :@JS (run in order)
		if Help.isHtmlFile file
			@reloadJS file
			return hasImports: false

		@initJS file
		return @JS if @fromReloadJS()

		htmlImports = @getHtmlImports()
		@JS.hasImports = !Help.isEmptyObject htmlImports
		@updateHtmlImportsMap htmlImports
		return @JS unless @JS.hasImports

		@inlineImports()
		HtmlImports[@JS.path].contents.compiled = @JS.contents
		@JS

	# Private Methods
	# ===============
	initJS: (file) -> # :void (@JS will be the return value for @get())
		_path = Help.getKeyPath file
		@JS =
			hasImports: false                    # does js contents have html import(s)
			dir:        path.dirname _path       # dist/client/scripts
			path:       _path                    # dist/client/scripts/xxx.js
			relPath:    file.relative            # scripts/xxx.js
			extname:    file.extname             # .js
			contents:   file.contents.toString() # original uninlined js contents (needed for html watch)

	fromReloadJS: -> # :boolean (for the watch)
		return false unless !!HtmlImports[@JS.path]
		@JS.contents is HtmlImports[@JS.path].contents.compiled

	getHtmlImports: -> # :htmlImports<hashmap> { jsPath: { statement:'', variable:'', html:'' }}
		htmlImports = {}
		@removeComments()
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
			htmlImport = { statement, path: importPath, variable, html }
			htmlImports[importDistPath] = htmlImport
		@addComments()
		htmlImports

	updateHtmlImportsMap: (htmlImports) -> # :void
		return delete HtmlImports[@JS.path] unless @JS.hasImports
		HtmlImports[@JS.path] = {
			imports: htmlImports
			contents:
				compiled: null
				uncompiled: @JS.contents
		}

	reloadJS: (file) -> # :void (for watching html files)
		return if Help.isEmptyObject HtmlImports
		htmlPath = Help.getKeyPath file
		jsFiles  = []
		for jsPath, jsFile of HtmlImports
			continue unless jsFile.imports[htmlPath]
			jsFiles.push jsPath
		return unless jsFiles.length
		for jsPath in jsFiles
			fse.pathExists(jsPath).then (exists) ->
				unless exists
					eMsg = "failed to inline html import, file doesn't exist: #{jsPath}"
					return console.error eMsg.error
				fse.outputFile jsPath, HtmlImports[jsPath].contents.uncompiled

	addComments: -> # :void
		return unless @comments.length
		i = 0; regx = new RegExp COMMENT_PLACEHOLDER, 'g'
		@JS.contents = @JS.contents.replace regx, (match) => @comments[i++]

	removeComments: -> # :void
		@comments = []
		@JS.contents = @JS.contents.replace Regx.comments, (match) =>
			@comments.push match
			COMMENT_PLACEHOLDER

	inlineImports: ->
		return unless !!HtmlImports[@JS.path]
		@removeComments()
		for htmlPath, htmlImport of HtmlImports[@JS.path].imports
			hasTemplateVar = false
			@JS.contents = @JS.contents.replace Regx.templateVar(htmlImport.variable), (match) ->
				hasTemplateVar = true
				"`#{htmlImport.html}`"
			if hasTemplateVar
				@JS.contents = @JS.contents.replace Regx.htmlImport(htmlImport.statement), ''
			else
				console.error "
					failed to inline js html import \"#{htmlImport.path}\"
					in file \"#{@JS.relPath}\",
					variable \"#{htmlImport.variable}\" unused
				".error
		@addComments()

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