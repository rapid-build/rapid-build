module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# init spa options
	# ================
	spa = options.spa
	spa = {} unless isType.object spa
	spa.autoInject    = null if not isType.array(spa.autoInject) and spa.autoInject isnt false
	spa.title         = null unless isType.string spa.title
	spa.description   = null unless isType.string spa.description
	spa.src           = {}   unless isType.object spa.src
	spa.src.filePath  = null unless isType.string spa.src.filePath
	spa.dist          = {}   unless isType.object spa.dist
	spa.dist.fileName = null unless isType.string spa.dist.fileName
	spa.placeholders  = null unless isType.array  spa.placeholders
	spa.scripts       = {}   unless isType.object spa.scripts
	spa.styles        = {}   unless isType.object spa.styles
	spa.scripts.attrs = null unless isType.object spa.scripts.attrs
	spa.styles.attrs  = null unless isType.object spa.styles.attrs

	# add spa options
	# ===============
	options.spa = spa

	# return
	# ======
	options


