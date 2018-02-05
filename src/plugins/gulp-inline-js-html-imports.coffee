# GULP PLUGIN: gulp-inline-js-html-imports
# Plugin level: function(dealing with files)
# Compiles html imports inside scripts.
# Currently no opts available.
# ==========================================
path        = require 'path'
fse         = require 'fs-extra'
through     = require 'through2'
PluginError = require 'plugin-error'
PLUGIN_NAME = 'gulp-inline-js-html-imports'
require('colors').setTheme error:['red','bold'] unless 'colors'.error

# CONSTANTS
# =========
COMMENT_PLACEHOLDER = '//RB_COMMENT_PLACEHOLDER'

# REGULAR EXPRESSIONS
# ===================
Regx =
	comments:
		/\/\*[\s\S]*?\*\/|([^\\:]|^)\/\/.*$/gm

	cssLinks:
		/<link\s+(?:[^>]*?\s+)?href=(?:"|')?([^"]*\.css)(?:"|')?[\s\S]*?>/g

	htmlImports:
		/\bimport\s+(?=[^;]+\.html)(?:(.+?)\s+from\s*?)?[\'"`]([^`"\']+\.html)[`"\'](?=\s*?(;|\/\/|\/\*|\n|$))(\s*;)?/g

	htmlImport: (statement) -> # :RegExp
		# /import template from '..\/views\/rb-nav.html';\n?/g
		new RegExp "#{statement}\\n?", 'g'

	templateVar: (variable) -> # :RegExp
		# \btemplate(?=\s*?(;|}|\/\/|\/\*|\n|$))(?!\s+?(:|\(|from))
		new RegExp "\\b#{variable}(?=\\s*?(;|}|\\/\\/|\\/\\*|\\n|$))(?!\\s+?(:|\\(|from))", 'g'

# HELPERS
# =======
Help =
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

	isInlineFile: (file, extname) -> # :boolean
		return false unless file
		return false if typeof file.extname isnt 'string'
		file.extname.toLowerCase().indexOf(extname) is -1

	logJson: (json, prefix) -> # :void (log pretty json)
		json = JSON.stringify json, null, '\t'
		return console.log json unless prefix
		console.log "#{prefix}:", json

	getKeyPath: (file) -> # :string | void
		return unless file
		path.join file.base, file.relative

# ASSETS (hashmap)
# jsPath:                 (dist/client/scripts/xxx.js)
# 	contents:
# 		compiled: ''      (the inlined js file contents)
# 		uncompiled: ''    (the uninlined js file contents)
# 	assets:
# 		assetPath:        (dist/client/views/xxx.html)
# 			statement: '' (import template from '../views/xxx.html';)
#           path: ''      (statement path '../views/xxx.html')
# 			variable: ''  (template)
# 			contents: ''  (html file contents)
# ======================================================================
Assets = {}

# COMPILER
# ========
InlineAssets =
	# Public Methods
	# ==============
	get: (file, opts={}) -> # :@File (run in order)
		@File = @getFile file

		if Help.isInlineFile file, '.js'
			@reload @File.path # html file
			return @File

		@update.File.contents.call @, file.contents.toString()
		@update.File.changed.call @, @File.path

		# console.log 'JS File CHANGED:', @File.changed
		return @File unless @File.changed
		assets = @getAssets @File.contents, @File.dir, @File.relPath

		if Help.isEmptyObject assets
			@update.Assets.delete @File.path
			@update.File.changed.call @, @File.path, false
			# Help.logJson assets, 'JS assets'
			return @File

		inlinedContents = @getInlinedContents assets, @File.contents, @File.relPath
		@update.Assets.add.call @, @File.path, inlinedContents, @File.contents, assets
		# Help.logJson Assets, 'JS ASSETS'
		@update.File.contents.call @, inlinedContents
		@File

	# Private Methods
	# ===============
	getFile: (file) -> # :{}<File> (called once and first in @get())
		_path = Help.getKeyPath file
		changed:  false              # did js change (needed for watch)
		dir:      path.dirname _path # dist/client/scripts
		path:     _path              # dist/client/scripts/xxx.js
		relPath:  file.relative      # scripts/xxx.js
		extname:  file.extname       # .js
		contents: null               # original uninlined js contents (needed for asset watch)

	# Updater
	# =======
	update:
		File: # (use with .call())
			changed: (_path, changed) -> # :void
				return @File.changed = changed if typeof changed is 'boolean'
				assets = Assets[_path]
				return @File.changed = true unless assets
				@File.changed = @File.contents isnt assets.contents.compiled

			contents: (contents) -> # :void
				@File.contents = contents

		Assets:
			add: (_path, compiled, uncompiled, assets={}) -> # :void
				Assets[_path] =
					assets: assets # {}<hashmap>
					contents:
						compiled: compiled     # :string (set after inlining assets)
						uncompiled: uncompiled # :string (will use in @reload)

			delete: (_path) -> # :void
				delete Assets[_path]

			contents:
				compiled: (_path, contents) -> # :void
					Assets[_path].contents.compiled = contents

	reload: (assetPath) -> # :void (for watching asset files)
		return if Help.isEmptyObject Assets
		# console.log 'JS ASSET PATH:', assetPath
		# Help.logJson Assets, 'JS ASSETS'
		assetPaths = []
		for _path, file of Assets
			continue unless file.assets[assetPath]
			assetPaths.push _path
			
		return unless assetPaths.length
		# Help.logJson assetPaths

		for _path in assetPaths
			exists = fse.pathExistsSync _path
			unless exists
				eMsg = "failed to inline html import, file doesn't exist: #{_path}"
				return console.error eMsg.error
			fse.outputFileSync _path, Assets[_path].contents.uncompiled

	getAssets: (contents, dir, relPath) -> # :assets<hashmap> { assetPath: { statement:'', path:'', variable:'', html:'' }}
		assets = {}
		file   = @removeComments contents
		while (match = Regx.htmlImports.exec(file.contents)) != null
			statement      = match[0] # import template from '../views/xxx.html';
			variable       = match[1] # template
			importPath     = match[2] # ../views/xxx.html
			importDistPath = path.join dir, importPath # dist/client/views/xxx.html
			try
				assetContents = fse.readFileSync importDistPath, 'utf8'
			catch e
				e.message = "html import file in #{relPath} doesn't exist: #{importPath}"
				console.error e.message.error
				continue
			asset = { statement, path: importPath, variable, contents: assetContents }
			assets[importDistPath] = asset
		# file = @addComments file
		assets

	getInlinedContents: (assets, contents, relPath) -> # :void
		file = @removeComments contents
		for assetPath, asset of assets
			hasTemplateVar = false
			file.contents = file.contents.replace Regx.templateVar(asset.variable), (match) ->
				hasTemplateVar = true
				"`#{asset.contents}`"
			if hasTemplateVar
				file.contents = file.contents.replace Regx.htmlImport(asset.statement), ''
			else
				console.error "
					failed to inline js html import \"#{asset.path}\"
					in file \"#{relPath}\",
					variable \"#{asset.variable}\" unused
				".error
		file = @addComments file
		file.contents

	addComments: (file) -> # :{}
		return file unless file.comments.length
		i = 0; regx = new RegExp COMMENT_PLACEHOLDER, 'g'
		file.contents = file.contents.replace regx, (match) => file.comments[i++]
		file

	removeComments: (contents) -> # :{}
		comments = []
		contents = contents.replace Regx.comments, (match) =>
			comments.push match
			COMMENT_PLACEHOLDER
		{ comments, contents }

# GULP PLUGIN
# ===========
inlineJsImportAssets = (opts={}) ->
	through.obj (file, enc, cb) ->
		return cb null, file unless file
		return cb null, file if file.isNull()
		return cb new PluginError PLUGIN_NAME, 'streaming not supported' if file.isStream()
		return cb null, file unless file.isBuffer()
		try
			js = InlineAssets.get file, opts
			return cb null unless js.changed
			file.contents = new Buffer js.contents
		catch e
			return cb new PluginError PLUGIN_NAME, e

		cb null, file

# EXPORT IT!
# ==========
module.exports = inlineJsImportAssets