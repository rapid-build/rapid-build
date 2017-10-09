# Helpers
# =======
tap = (o, fn) -> fn(o); o
merge = (xs...) ->
	if xs?.length > 0
		tap {}, (m) -> m[k] = v for k, v of x for x in xs

logBuildMsg = (build, optionsFor) ->
	msg = 'setting ' + build + ' build options'
	console.log optionsFor + ': ' + msg
	return

getOptFileName = (fileName) -> # convert camelCase to spinal-case
	letters = fileName.split ''
	for letter in letters
		continue unless letter is letter.toUpperCase()
		fileName = fileName.replace letter, "-#{letter.toLowerCase()}"
	fileName

# Common Build Options
# ====================
getCommonOptions = ->
	options         = {}
	optsDir         = 'build-options'
	RB_TEST_OPTIONS = process.env.RB_TEST_OPTIONS
	return options unless RB_TEST_OPTIONS
	opts = RB_TEST_OPTIONS.split ':'
	for optFile in opts
		optFile = getOptFileName optFile
		options = merge options, require "./#{optsDir}/#{optFile}"
	options

# Dev Build Options
# =================
setDevOptions = (options) ->
	# add to or modify options here, example below:
	# options.build = client: false
	return

# CI Build Options
# =================
setCiOptions = (options) ->
	# add to or modify options here, example below:
	# options.build = client: false
	return

# Get Build Options
# =================
getOptions = (build, isCiBuild) ->
	logBuildMsg build, 'common'
	options = getCommonOptions()
	if !isCiBuild then logBuildMsg(build, 'dev') else logBuildMsg(build, 'ci')
	if !isCiBuild then setDevOptions(options) else setCiOptions(options)
	options

# Export it!
# ==========
module.exports = getOptions