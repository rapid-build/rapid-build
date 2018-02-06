# GULP PLUGIN: gulp-inline-html-assets
# Plugin level: function(dealing with files)
# Inlines html assets inside html files.
# Currently no opts available.
# ==========================================
path        = require 'path'
fse         = require 'fs-extra'
through     = require 'through2'
PluginError = require 'plugin-error'
inliner     = require('inline-source').sync
PLUGIN_NAME = 'gulp-inline-html-assets'
require('colors').setTheme error:['red','bold'] unless 'colors'.error

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

	getInlineKeyPath: (assetPath, htmlDir) -> # :string | void
		# htmlDir   (path in html file: dist/client/views
		# assetPath (path in html file: /Users/project/dist/client/styles/test.css
		return unless assetPath
		assetPath = path.relative htmlDir, assetPath # ../styles/xxx.css
		path.join htmlDir, assetPath # dist/client/styles/xxx.css

# ASSETS (hashmap)
# htmlPath:            (key ex: dist/client/views/xxx.html)
# 	contents:
# 		compiled: ''   (the inlined html file contents)
# 		uncompiled: '' (the uninlined html file contents)
# 	assets: ['']       (paths: dist/client/styles/xxx.css)
# =========================================================
Assets = {}

# COMPILER
# ========
InlineAssets =
	# Public Methods
	# ==============
	get: (file, opts={}) -> # :@File (run in order)
		@File = @getFile file

		if Help.isInlineFile file, '.html'
			@reload @File.path # file path: css or js
			return @File

		@update.File.contents.call @, file.contents.toString()
		@update.File.changed.call @, @File.path

		# console.log 'HTML CHANGED:', @File.changed
		return @File unless @File.changed
		inlined = @inlineAssets @File.contents, @File.dir, @File.relPath, opts

		if inlined.error or not inlined.assets.length
			# console.log 'ERROR OR NO ASSETS:', true
			@update.Assets.delete @File.path
			@update.File.changed.call @, @File.path, false
			return @File

		@update.Assets.add.call @, @File.path, inlined.contents, @File.contents, inlined.assets
		# Help.logJson Assets, 'HTML ASSETS'
		@update.File.contents.call @, inlined.contents
		@File

	# Private Methods
	# ===============
	getFile: (file) -> # :{}<File> (called once and first in @get())
		_path = Help.getKeyPath file
		changed:  false              # did html change (needed for watch)
		dir:      path.dirname _path # dist/client/views
		path:     _path              # dist/client/views/xxx.html
		relPath:  file.relative      # views/xxx.html
		extname:  file.extname       # .html
		contents: null               # original uninlined html contents (needed for asset watch)

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
			add: (_path, compiled, uncompiled, assets=[]) -> # :void
				Assets[_path] =
					assets: assets # string[]
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
		# console.log 'ASSET PATH:', assetPath
		# Help.logJson Assets, 'HTML ASSETS'
		assetPaths = []
		for _path, file of Assets
			continue unless file.assets.length
			continue unless file.assets.includes assetPath
			assetPaths.push _path

		return unless assetPaths.length
		# Help.logJson assetPaths, 'HTML assetPaths'

		for _path in assetPaths
			exists = fse.pathExistsSync _path
			unless exists
				eMsg = "failed to inline html assets, file doesn't exist: #{_path}"
				return console.error eMsg.error
			fse.outputFileSync _path, Assets[_path].contents.uncompiled

	inlineAssets: (contents, dir, relPath, inlineOpts={}) -> # :HtmlAsset{}
		inlined = assets: [], error: null, contents: null
		try
			opts =
				attribute: false # included in inlineOpts
				compress: false
				rootpath: dir
				handlers: [
					(source, context) -> # next() not working with .sync
						return unless source.filepath
						assetPath = Help.getInlineKeyPath source.filepath, dir
						inlined.assets.push assetPath
				]
			Object.assign opts, inlineOpts
			inlined.contents = inliner contents, opts # inliner bug: one line with no html
		catch e
			inlined.error = e
			console.error "failed to inline html assets in file \"#{relPath}\"".error
			console.error "#{e.message}".error
		inlined

# GULP PLUGIN
# ===========
inlineHtmlAssets = (opts={}) ->
	through.obj (file, enc, cb) ->
		return cb null, file unless file
		return cb null, file if file.isNull()
		return cb new PluginError PLUGIN_NAME, 'streaming not supported' if file.isStream()
		return cb null, file unless file.isBuffer()
		try
			html = InlineAssets.get file, opts
			return cb null unless html.changed
			file.contents = new Buffer html.contents
		catch e
			return cb new PluginError PLUGIN_NAME, e

		return cb null, file

# EXPORT IT!
# ==========
module.exports = inlineHtmlAssets