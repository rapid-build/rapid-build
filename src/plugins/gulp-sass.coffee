# GULP PLUGIN: gulp-sass
# gulp-sass v4.0.2 (10/19/2018)
# https://github.com/dlmanning/gulp-sass/blob/v4.0.2/index.js
# Reason for not using gulp-sass package:
# Want to use sass package instead of node-sass.
# At this time node-sass is dependency of gulp-sass.
# ===========================================================
path             = require 'path'
sassCompiler     = require 'sass'
through          = require 'through2'
replaceExtension = require 'replace-ext'
PluginError      = require 'plugin-error'
clonedeep        = require 'lodash.clonedeep'
applySourceMap   = require 'vinyl-sourcemaps-apply'
PLUGIN_NAME      = 'gulp-sass'
require('colors').setTheme error:['red','bold'] unless 'colors'.error

# HELPERS
# =======
Help =
	_getIncludePaths: (includePaths=[]) -> # :string[]
		return [includePaths] if typeof includePaths is 'string'
		includePaths

	getOpts: (file, options) -> # object
		opts = clonedeep options
		opts.data           = file.contents.toString()
		opts.file           = file.path                                  # set file path here so libsass can correctly resolve import paths
		opts.indentedSyntax = true if path.extname(file.path) is '.sass' # ensure indentedSyntax is true if .sass file
		opts.includePaths   = @_getIncludePaths opts.includePaths
		opts.includePaths.unshift path.dirname file.path                 # ensure file's parent directory is in include path
		return opts unless file.sourceMap                                # generate source maps if plugin source-map present
		opts.sourceMap         = file.path
		opts.omitSourceMapUrl  = true
		opts.sourceMapContents = true
		opts

	_buildSrcMap: (file, sassObj) -> # :void (file mutator, adds file.sourceMap)
		return unless sassObj.map
		sassMap         = JSON.parse sassObj.map.toString()        # transform map into json
		sassMapFile     = sassMap.file.replace /^stdout$/, 'stdin' # grab stdout and transform it into stdin
		sassFileSrc     = file.relative                            # grab base file name that's being worked on
		sassFileSrcPath = path.dirname sassFileSrc                 # grab path portion of  file that's being worked on

		if sassFileSrcPath # prepend path to all files in sources array except file that's being worked on
			sourceFileIndex = sassMap.sources.indexOf sassMapFile
			sassMap.sources = sassMap.sources.map (source, index) ->
				if index is sourceFileIndex then source else path.join sassFileSrcPath, source

		sassMap.sources = sassMap.sources.filter (src) -> # remove stdin from souces and replace with filenames
			src isnt 'stdin' and src

		sassMap.file = replaceExtension sassFileSrc, '.css' # replace map file with original file name (but new extension)
		applySourceMap file, sassMap                        # apply map
		return

	buildFile: (file, sassObj) -> # :void (file mutator, adds file[contents, path])
		@_buildSrcMap file, sassObj
		file.contents = sassObj.css
		file.path     = replaceExtension file.path, '.css'
		return

	renderAsync: (opts) -> # :Promise<object>
		new Promise (resolve, reject) ->
			gulpSass.compiler.render opts, (error, sassObj) ->
				return reject error if error
				resolve sassObj

	renderSync: (opts) -> # :Promise<object>
		new Promise (resolve, reject) ->
			try
				resolve gulpSass.compiler.renderSync opts
			catch error
				reject error

# Gulp Plugin
# ===========
gulpSass = (options={}, sync=false) ->
	through.obj (file, enc, cb) ->
		return cb null, file if file.isNull()
		return cb new PluginError PLUGIN_NAME, 'streaming not supported' if file.isStream()
		return cb() if path.basename(file.path).indexOf('_') is 0 # handle sass partials
		if !file.contents.length
			file.path = replaceExtension file.path, '.css'
			return cb null, file

		# Get Options
		opts   = Help.getOpts file, options
		render = if sync is true then 'renderSync' else 'renderAsync'

		# Render Sass (async or sync)
		Help[render](opts).then (sassObj) ->
			Help.buildFile file, sassObj
			cb null, file # push file
		.catch (error) ->
			cb new PluginError PLUGIN_NAME, error

# Render Sass Sync
# ================
gulpSass.sync = (options) ->
	gulpSass options, true

# Store Compiler in Prop
# ======================
gulpSass.compiler = sassCompiler

# Export It!
# ==========
module.exports = gulpSass