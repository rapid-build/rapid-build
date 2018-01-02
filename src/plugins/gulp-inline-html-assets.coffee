# GULP PLUGIN: gulp-inline-html-assets
# Plugin level: function(dealing with files)
# Inlines html assets inside html files.
# Currently no opts available.
# ==========================================
path        = require 'path'
fse         = require 'fs-extra'
through     = require 'through2'
gutil       = require 'gulp-util'
inliner     = require('inline-source').sync
PLUGIN_NAME = 'gulp-inline-html-assets'
PluginError = gutil.PluginError
require('colors').setTheme error:['red','bold'] unless 'colors'.error

# HELPERS
# =======
Help =
	getAssetlKeyPath: (assetPath, htmlDir) -> # :string | void
		# htmlDir   (path in html file: dist/client/views
		# assetPath (path in html file: /Users/project/dist/client/styles/test.css
		return unless assetPath
		assetPath = path.relative htmlDir, assetPath # ../styles/xxx.css
		path.join htmlDir, assetPath # dist/client/styles/xxx.css

	getHtmlKeyPath: (file) -> # :string | void
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

	isCssFile: (extname) -> # :boolean
		return false if typeof extname isnt 'string'
		extname.toLowerCase().indexOf('.css') isnt -1

	logJson: (json, prefix) -> # :void (log pretty json)
		json = JSON.stringify json, null, '\t'
		return console.log json unless prefix
		console.log "#{prefix}:", json

# HTML ASSETS (hashmap)
# htmlPath:            (key ex: dist/client/views/xxx.html)
# 	assets: ['']       (paths: dist/client/styles/xxx.css)
# 	contents:
# 		compiled: ''   (the inlined html file contents)
# 		uncompiled: '' (the uninlined html file contents)
# =========================================================
HtmlAssets = {}

# COMPILER
# ========
InlineHtmlAssets =
	# Public Methods
	# ==============
	get: (file, opts={}) -> # :@HTML (run in order)
		@HTML = @getHTML file

		if Help.isCssFile @HTML.extname
			@reloadHTML @HTML.path # this is the css file path
			return @HTML

		@update.HTML.contents.call @, file.contents.toString()
		@update.HTML.changed.call @, @HTML.path

		# console.log 'HTML CHANGED:', @HTML.changed
		return @HTML unless @HTML.changed

		inlined = @inlineAssets @HTML.contents, @HTML.dir, @HTML.relPath

		if inlined.error or not inlined.assets.length
			# console.log 'ERROR OR NO ASSETS:', true
			@update.HtmlAssets.delete @HTML.path
			@update.HTML.changed.call @, @HTML.path, false
			return @HTML

		@update.HtmlAssets.add.call @, @HTML.path, @HTML.contents, inlined.contents, inlined.assets
		# Help.logJson HtmlAssets, 'HTML ASSETS'
		@update.HTML.contents.call @, inlined.contents

		@HTML

	# Private Methods
	# ===============
	getHTML: (file) -> # :{}<HTML> (called once and first in @get())
		_path = Help.getHtmlKeyPath file
		changed:  false              # did html change (needed for watch)
		dir:      path.dirname _path # dist/client/views
		path:     _path              # dist/client/views/xxx.html
		relPath:  file.relative      # views/xxx.html
		extname:  file.extname       # .html
		contents: null               # original uninlined html contents (needed for css watch)

	# Updater (use with .call())
	# =======
	update:
		HTML:
			changed: (htmlPath, changed) -> # :void
				return @HTML.changed = changed if typeof changed is 'boolean'
				htmlAssets = HtmlAssets[htmlPath]
				return @HTML.changed = true unless htmlAssets
				@HTML.changed = @HTML.contents isnt htmlAssets.contents.compiled

			contents: (html) -> # :void
				@HTML.contents = html

		HtmlAssets:
			add: (htmlPath, uncompiledHtml, compiledHtml, assets=[]) -> # :void
				HtmlAssets[htmlPath] =
					assets: assets # string[]
					contents:
						compiled: compiledHtml # :string (set after inlining assets)
						uncompiled: uncompiledHtml # :string (will use in @reloadHTML)

			delete: (htmlPath) -> # :void
				delete HtmlAssets[htmlPath]

			contents:
				compiled: (htmlPath, html) -> # :void
					HtmlAssets[htmlPath].contents.compiled = html

	reloadHTML: (assetPath) -> # :void (for watching css files)
		return if Help.isEmptyObject HtmlAssets

		# console.log 'ASSET PATH:', assetPath
		# Help.logJson HtmlAssets, 'HTML ASSETS'

		htmlPaths = []
		for htmlPath, htmlFile of HtmlAssets
			continue unless htmlFile.assets.length
			continue unless htmlFile.assets.includes assetPath
			htmlPaths.push htmlPath

		return unless htmlPaths.length
		# Help.logJson htmlPaths

		for htmlPath in htmlPaths
			exists = fse.pathExistsSync htmlPath
			unless exists
				eMsg = "failed to inline html assets, file doesn't exist: #{htmlPath}"
				return console.error eMsg.error

			fse.outputFileSync htmlPath, HtmlAssets[htmlPath].contents.uncompiled

	inlineAssets: (html, htmlDir, htmlRelPath) -> # :void
		inlinedHtml = assets: [], error: null, contents: null
		try
			opts =
				compress: false
				attribute: false
				rootpath: htmlDir
				handlers: [
					(source, context) -> # next() not working with .sync
						return unless source.filepath
						assetPath = Help.getAssetlKeyPath source.filepath, htmlDir
						inlinedHtml.assets.push assetPath
				]
			inlinedHtml.contents = inliner html, opts
		catch e
			inlinedHtml.error = e
			console.error "failed to inline html assets in file \"#{htmlRelPath}\"".error
			console.error "#{e.message}".error
		inlinedHtml

# GULP PLUGIN
# ===========
inlineHtmlAssets = (opts={}) ->
	through.obj (file, enc, cb) ->
		return cb null, file unless file
		return cb null, file if file.isNull()
		return cb new PluginError PLUGIN_NAME, 'streaming not supported' if file.isStream()
		return cb null, file unless file.isBuffer()
		try
			html = InlineHtmlAssets.get file, opts
			return cb null unless html.changed
			file.contents = new Buffer html.contents
		catch e
			return cb new PluginError PLUGIN_NAME, e

		return cb null, file

# EXPORT IT!
# ==========
module.exports = inlineHtmlAssets