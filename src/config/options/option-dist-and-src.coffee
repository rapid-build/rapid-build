module.exports = (config, options) ->
	isType = require "#{config.req.helpers}/isType"

	# build dist and src directories
	# ==============================
	['dist', 'src'].forEach (v1) ->
		options[v1] = {} unless isType.object options[v1]
		options[v1].dir = null unless isType.string options[v1].dir
		['client', 'server'].forEach (v2) ->
			# dir
			options[v1][v2] = {} unless isType.object options[v1][v2]
			options[v1][v2].dir = null unless isType.string options[v1][v2].dir
			# types dir
			if v2 is 'server'
				['test'].forEach (v3) ->
					options[v1][v2][v3] = {} unless isType.object options[v1][v2][v3]
					options[v1][v2][v3].dir = null unless isType.string options[v1][v2][v3].dir
			else
				['bower', 'images', 'libs', 'scripts', 'styles', 'test', 'views'].forEach (v3) ->
					options[v1][v2][v3] = {} unless isType.object options[v1][v2][v3]
					options[v1][v2][v3].dir = null unless isType.string options[v1][v2][v3].dir

	# app server dist entry file
	# ==========================
	options.dist.server.fileName = null unless isType.string options.dist.server.fileName

	# absolute client paths
	# =====================
	options.dist.client.paths = {} unless isType.object options.dist.client.paths
	options.dist.client.paths.absolute = null unless isType.boolean options.dist.client.paths.absolute

	# pack dist
	# =========
	options.dist.pack = {} unless isType.object options.dist.pack
	options.dist.pack.enable      = null unless isType.boolean options.dist.pack.enable
	options.dist.pack.format      = null unless isType.string options.dist.pack.format
	options.dist.pack.fileName    = null unless isType.string options.dist.pack.fileName
	options.dist.pack.glob        = null unless isType.string(options.dist.pack.glob) or isType.stringArray options.dist.pack.glob
	options.dist.pack.includeBase = null unless isType.boolean options.dist.pack.includeBase

	# return
	# ======
	options


