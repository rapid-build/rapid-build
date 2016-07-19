PLUGIN_NAME     = 'gulp-absolute-css-urls'
through         = require 'through2'
gutil           = require 'gulp-util'
path            = require 'path'
PluginError     = gutil.PluginErrors
# for find and replace - added negative lookahead to not match comments
urlRegX         = /url\s*\(\s*['"]?(.*?)['"]?\s*\)(?![^\*]*?\*\/)/g
importNoUrlRegX = /@import\s*?['"]+?(.*?)['"]+?(?![^\*]*?\*\/)/g

# Helpers
# =======
pathHelp =
	isWin: (_path) ->
		_path.indexOf('\\') isnt -1

	isWinAbs: (_path) ->
		_path.indexOf(':\\') isnt -1

	removeDrive: (_path) ->
		return _path unless @isWinAbs _path
		i     = _path.indexOf(':\\') + 1
		_path = _path.substr i

	swapBackslashes: (_path) ->
		regx = /\\/g
		_path.replace regx, '/'

	format: (_path) ->
		return _path unless @isWin _path
		_path = @removeDrive _path
		_path = @swapBackslashes _path
		_path

	hasTrailingSlash: (_path) ->
		_path[_path.length-1] is '/'

	isAbsolute: (urlPath) ->
		urlPath[0] is '/'

	isExternal: (urlPath) ->  # like from http
		urlPath.indexOf('//') isnt -1

	isImport: (_path) ->
		path.extname(_path) is '.css'

	getRelative: (paths) ->
		_path = path.resolve paths.abs, paths.url
		pathHelp.format _path

	getAbsolute: (paths, opts) ->
		prependPath = opts.prependPath isnt false
		base        = paths.base # /Users/jyounce/npm-packages/build-test/dist/client/libs/
		rel         = paths.rel  # build/styles/x.css
		# console.log "Base: #{base} | Rel: #{rel}"
		base        = base.split '/'
		# console.log base
		base        = base[base.length-2]
		base        = "/#{base}" # /libs
		# console.log "Base: #{base}"
		rel         = rel.split '/'
		rel         = rel[0] # build
		rel         = "/#{rel}"
		# console.log "Rel: #{rel}"
		_path       = ''
		_path       = "#{base}#{rel}" if prependPath
		_path       = "/#{opts.rbDistDir}#{_path}" if paths.isRbPath
		_path       = "#{_path}#{paths.url}" # /libs/build/images/x.png
		# console.log _path
		_path

	getCssUrl: (_path) ->
		_path = @format _path
		url   = "url('#{_path}')" # url('/libs/build/images/x.png')

	getCssImport: (_path) ->
		_path   = @format _path
		_import = "@import '#{_path}'" # @import '/styles/imports/x.css'

	getImport: (_path, paths) ->
		return unless @isImport _path
		_path = "#{paths.root}#{_path}"

	formatCssUrl: (match, formatTask, config, paths={}, opts={}) ->
		isExternal = @isExternal paths.url
		return url: match if isExternal
		isAbsolute = @isAbsolute paths.url
		msg        = if isAbsolute then 'absolute' else 'relative'
		_path      = if isAbsolute then @getAbsolute paths, opts else @getRelative paths
		_import    = @getImport _path, paths
		# console.log "#{msg}: #{_path}"
		url        = pathHelp[formatTask] _path
		{ url, _import }

format =
	root: (_path) -> # need a beginning / and no trailing /
		return null unless _path
		_path  = _path.trim()
		_path  = pathHelp.swapBackslashes _path
		_path  = _path.slice 0, -1 if _path.length > 1 and pathHelp.hasTrailingSlash _path
		return null  if _path.length is 1 and _path[0] is '/'
		return _path if _path.indexOf('/') is 0
		_path  = "/#{_path}"

	absPath: (file, root) ->
		_path = file.path.replace file.cwd, ''
		_path = pathHelp.swapBackslashes _path
		_path = _path.replace root, ''
		_path = path.dirname _path

addConfigImports = (imports, config, paths) ->
	appOrRb  = if paths.isRbPath then 'rb' else 'app'
	cImports = config.internal[appOrRb].client.css.imports
	key      = "#{paths.root}#{paths.abs}/#{paths.rel}"
	unless imports.length
		delete cImports[key] if cImports[key]
		return
	cImports[key] = imports

findAndReplace = (css, config, paths, opts, imports, formatTask, regX) ->
	css.replace regX, (match, urlPath) ->
		paths.url = urlPath
		_css = pathHelp.formatCssUrl match, formatTask, config, paths, opts
		imports.push _css._import if _css._import
		_css.url

# Main (replace relative urls with absolute urls)
# ===============================================
replaceCssUrls = (file, root, config, opts={}) ->
	css        = file.contents.toString()
	_root      = format.root root
	abs        = format.absPath file, _root
	base       = pathHelp.format file.base
	rel        = pathHelp.format file.relative
	rbDistPath = pathHelp.format opts.rbDistPath
	isRbPath   = base.indexOf(rbDistPath) isnt -1
	paths      = { root, abs, base, rel, isRbPath }
	imports    = []

	# urlPath = ../images/superheroes.png | /images/superheroes.png
	css = findAndReplace css, config, paths, opts, imports, 'getCssUrl', urlRegX            # match = url('../images/x.png')
	css = findAndReplace css, config, paths, opts, imports, 'getCssImport', importNoUrlRegX # match = @import 'imports/x.css'

	addConfigImports imports, config, paths
	css

# Plugin level function(dealing with files)
# root is the path to resolve urls from
# =========================================
gulpAbsoluteCssUrls = (root, config, opts) ->
	through.obj (file, enc, cb) ->
		return cb null, file if file.isNull() # return empty file
		return cb new PluginError PLUGIN_NAME, 'streaming not supported' if file.isStream()

		if file.isBuffer()
			contents      = replaceCssUrls file, root, config, opts
			file.contents = new Buffer contents

		cb null, file

module.exports = gulpAbsoluteCssUrls



