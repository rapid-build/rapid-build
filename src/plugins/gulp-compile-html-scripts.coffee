# GULP PLUGIN: gulp-compile-html-scripts
# Plugin level: function(dealing with files)
# Compiles es6 inside html script tags.
# Currently no opts available.
# ==========================================
through     = require 'through2'
gutil       = require 'gulp-util'
babel       = require 'babel-core'
es2015      = require 'babel-preset-es2015'
PLUGIN_NAME = 'gulp-compile-html-scripts'
PluginError = gutil.PluginError

# Regular Expressions
# ===================
regx = {}

regx.str =
	all:
		# [\s\S]*?
		'[\\s\\S]*?'

	htmlCmts:
		# <!--[\s\S]*?-->
		'<!--[\\s\\S]*?-->'

	scriptEnd:
		# <\s*?\/\s*?script\s*?>
		'<\\s*?\\/\\s*?script\\s*?>'

	scriptEndTemp:
		'</TEMP_SCRIPT_END>'

regx.obj =
	jsCmts:
		# \/\/.*<\s*?\/\s*?script\s*?>|\/\*[\s\S]*?\*\/
		new RegExp "\\/\\/.*#{regx.str.scriptEnd}|\\/\\*#{regx.str.all}\\*\\/", 'gi'

	jsCmtsScriptEndTemp:
		new RegExp regx.str.scriptEndTemp, 'g'

	scripts:
		# <!--[\s\S]*?-->|<\s*?script(?:[\s\S](?!src\s*?=\s*\"))*?>([\s\S]*?)<\s*?\/\s*?script\s*?>
		new RegExp "#{regx.str.htmlCmts}|<\\s*?script(?:[\\s\\S](?!src\\s*?=\\s*\"))*?>(#{regx.str.all})#{regx.str.scriptEnd}", 'gi'

	scriptEnd:
		new RegExp regx.str.scriptEnd, 'gi'

# Compiler
# ========
compileScripts =
	opts:
		babel:
			presets: [es2015]

	get: (file, opts) -> # :string
		@_setOpts file, opts
		html = file.contents.toString()
		html = html.replace regx.obj.jsCmts, @_jsCmtsScriptEndReplace
		html = html.replace regx.obj.scripts, @_scriptReplace
		html = html.replace regx.obj.jsCmtsScriptEndTemp, '< /script>' # add space to maintain syntax highlighting in editors
		html

	_setOpts: (file, opts={}) -> # :void
		@opts.babel.filename         = file.path
		@opts.babel.filenameRelative = file.relative
		Object.assign @opts, opts

	_compile: (script) -> # :{}
		result = babel.transform script, @opts.babel
		result.code

	# skip if inside html comment, external script or empty script tag
	_scriptReplace: (match, codeMatch, offset, html) -> # :string
		return match unless typeof codeMatch is 'string'
		return match unless codeMatch.trim().length
		compiledScript = compileScripts._compile codeMatch
		match = match.replace codeMatch, -> compiledScript # callback to disable special replacement patterns, ex: $'
		# console.log 'MATCH:', match
		match

	_jsCmtsScriptEndReplace: (match, offset, html) -> # :string
		match = match.replace regx.obj.scriptEnd, regx.str.scriptEndTemp
		match

# Gulp Plugin
# ===========
compileHtmlScripts = (opts={}) ->
	through.obj (file, enc, cb) ->
		return cb null, file unless file
		return cb null, file if file.isNull()
		return cb new PluginError PLUGIN_NAME, 'streaming not supported' if file.isStream()
		return cb null, file unless file.isBuffer()
		# console.log file.path
		try
			compiledHtml  = compileScripts.get file, opts
			file.contents = new Buffer compiledHtml
		catch e
			return cb new PluginError PLUGIN_NAME, e

		cb null, file

# Export It!
# ==========
module.exports = compileHtmlScripts