PLUGIN_NAME   = 'gulp-ng-formify'
through       = require 'through2'
gutil         = require 'gulp-util'
PluginError   = gutil.PluginErrors

# For find and replace
# ====================
openTagRegEx  = new RegExp '<\\s*\\bform', 'gm'
closeTagRegEx = new RegExp '<\\s*/\\s*\\bform', 'gm'
openTag       = '<ng:form'
closeTag      = '</ng:form'

# Helpers
# =======
ngFormify = (contents) ->
	contents.replace openTagRegEx,  openTag
			.replace closeTagRegEx, closeTag

# Plugin level function(dealing with files)
# =========================================
gulpNgFormify = ->
	through.obj (file, enc, cb) ->
		return cb null, file if file.isNull() # return empty file
		return cb new PluginError PLUGIN_NAME, 'streaming not supported' if file.isStream()

		if file.isBuffer()
			contents      = ngFormify file.contents.toString()
			file.contents = new Buffer contents

		cb null, file

module.exports = gulpNgFormify