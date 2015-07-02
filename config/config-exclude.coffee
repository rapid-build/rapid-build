module.exports = (config, options) ->
	path     = require 'path'
	log      = require "#{config.req.helpers}/log"
	isType   = require "#{config.req.helpers}/isType"
	pathHelp = require "#{config.req.helpers}/path"
	test     = require("#{config.req.helpers}/test")()

	# options helpers
	# ===============
	get =
		opt:
			deep2: (type, opt, defaultVal) ->
				opt = options.exclude[type][opt]
				return defaultVal if isType.null opt
				opt
			deep3: (type, opt, defaultVal) ->
				opt = options.exclude[type].from[opt]
				return defaultVal if isType.null opt
				opt

	# init exclude
	# ============
	exclude =
		angular:
			files: get.opt.deep2 'angular', 'files', false
		rb:
			scripts:
				from:
					minFile: []
					spaFile: []
			styles:
				from:
					minFile: []
					spaFile: []
		app:
			scripts:
				from:
					minFile: get.opt.deep3 'scripts', 'minFile', []
					spaFile: get.opt.deep3 'scripts', 'spaFile', []
			styles:
				from:
					minFile: get.opt.deep3 'styles', 'minFile', []
					spaFile: get.opt.deep3 'styles', 'spaFile', []

	# format options
	# ==============
	formatFilesFrom = (type, opt) -> # prepend dist path to values then prepend '!'
		for appOrRb in ['app','rb']
			_paths = exclude[appOrRb][type].from[opt]
			continue if not _paths.length
			_paths = (pathHelp.makeRelative _path for _path in _paths)
			_paths = (path.join config.dist[appOrRb].client.dir, _path for _path in _paths)
			_paths = ("!#{_path}" for _path in _paths)
			# log.json _paths
			exclude[appOrRb][type].from[opt] = _paths

	formatFilesFrom 'scripts', 'minFile'
	formatFilesFrom 'scripts', 'spaFile'
	formatFilesFrom 'styles',  'minFile'
	formatFilesFrom 'styles',  'spaFile'

	# add exclude to config
	# =====================
	config.exclude = exclude

	# logs
	# ====
	# log.json exclude, 'exclude ='

	# tests
	# =====
	test.log 'true', config.exclude, 'add exclude to config'

	# return
	# ======
	config


