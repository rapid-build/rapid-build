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
			deep3: (opt, type, defaultVal) ->
				opt = options.exclude.from[opt][type]
				return defaultVal if isType.null opt
				opt

	# init exclude
	# ============
	exclude =
		angular:
			files: get.opt.deep2 'angular', 'files', false
		rb:
			from:
				cacheBust: []
				minFile:
					scripts: []
					styles:  []
				spaFile:
					scripts: []
					styles:  []
		app:
			from:
				cacheBust: get.opt.deep2 'from', 'cacheBust', []
				minFile:
					scripts: get.opt.deep3 'minFile', 'scripts', []
					styles:  get.opt.deep3 'minFile', 'styles',  []
				spaFile:
					scripts: get.opt.deep3 'spaFile', 'scripts', []
					styles:  get.opt.deep3 'spaFile', 'styles',  []

	# format options
	# ==============
	formatFilesFrom = (opt, type) -> # prepend dist path to values then prepend '!'
		for appOrRb in ['app','rb']
			_paths  = exclude[appOrRb].from[opt][type]
			forType = !!_paths
			_paths  = exclude[appOrRb].from[opt] unless forType
			continue unless _paths.length
			_paths = (pathHelp.makeRelative _path for _path in _paths)
			_paths = (path.join config.dist[appOrRb].client.dir, _path for _path in _paths)
			_paths = ("!#{_path}" for _path in _paths)
			# log.json _paths
			if forType
				exclude[appOrRb].from[opt][type] = _paths
			else
				exclude[appOrRb].from[opt] = _paths

	formatFilesFrom 'cacheBust'
	formatFilesFrom 'minFile', 'scripts'
	formatFilesFrom 'minFile', 'styles'
	formatFilesFrom 'spaFile', 'scripts'
	formatFilesFrom 'spaFile', 'styles'

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


