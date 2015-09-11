PLUGIN_NAME = 'gulp-relative-to-absolute-css-urls'
through     = require 'through2'
gutil       = require 'gulp-util'
path        = require 'path'
PluginError = gutil.PluginErrors
urlRegex    = /url\s*\(\s*['"]?([^\/].*?)['"]?\s*\)/g # for find and replace

# Helpers
# =======
swapBackslashes = (_path) ->
	regx = /\\/g
	_path.replace regx, '/'

hasTrailingSlash = (_path) ->
	_path[_path.length-1] is '/'

formatAbsFromPath = (_path) -> # need a beginning / and no trailing /
	return null if not _path
	_path  = _path.trim()
	_path  = swapBackslashes _path
	_path  = _path.slice 0, -1 if _path.length > 1 and hasTrailingSlash _path
	return null  if _path.length is 1 and _path[0] is '/'
	return _path if _path.indexOf('/') is 0
	_path  = "/#{_path}"

formatAbsPath = (file, absFromPath) ->
	_path = file.path.replace file.cwd, ''
	_path = swapBackslashes _path
	_path = _path.replace absFromPath, ''
	_path = path.dirname _path

# Main (replace relative urls with absolute urls)
# ===============================================
replaceCssUrls = (file, absFromPath) ->
	css         = file.contents.toString()
	absFromPath = formatAbsFromPath absFromPath
	absPath     = formatAbsPath file, absFromPath

	css = css.replace urlRegex, (match, urlPath) ->
		first      = urlPath[0]
		second     = urlPath[1]
		first2     = first + second
		isAbsolute = first2 is "'/" or first2 is '"/'
		isExternal = urlPath.toLowerCase().indexOf('//') isnt -1 # like from http
		return match if isAbsolute
		return match if isExternal
		_path = path.resolve absPath, urlPath
		# console.log _path
		# url = _path.replace(/'/g,'').replace(/"/g,'') # old sauce, why was this here??
		url = "url('#{_path}')"
		url
	css

# Plugin level function(dealing with files)
# =========================================
gulpRelativeToAbsoluteCssUrls = (absFromPath) ->
	through.obj (file, enc, cb) ->
		return cb null, file if file.isNull() # return empty file
		return cb new PluginError PLUGIN_NAME, 'streaming not supported' if file.isStream()

		if file.isBuffer()
			contents      = replaceCssUrls file, absFromPath
			file.contents = new Buffer contents

		cb null, file

module.exports = gulpRelativeToAbsoluteCssUrls




