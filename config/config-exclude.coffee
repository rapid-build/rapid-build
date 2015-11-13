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
			deep3: (base, opt, type, defaultVal) ->
				opt = options.exclude[base][opt][type]
				return defaultVal if isType.null opt
				opt

	# init exclude
	# ============
	exclude =
		spa: !!options.exclude.spa
		angular:
			files: get.opt.deep2 'angular', 'files', false
		default:
			client:
				files: get.opt.deep3 'default', 'client', 'files', false
			server:
				files: get.opt.deep3 'default', 'server', 'files', false
		rb:
			from:
				cacheBust: []
				minFile:
					scripts: []
					styles:  []
				spaFile:
					scripts: []
					styles:  []
				dist:
					client: []
					server: []
		app:
			from:
				cacheBust: get.opt.deep2 'from', 'cacheBust', []
				minFile:
					scripts: get.opt.deep3 'from', 'minFile', 'scripts', []
					styles:  get.opt.deep3 'from', 'minFile', 'styles',  []
				spaFile:
					scripts: get.opt.deep3 'from', 'spaFile', 'scripts', []
					styles:  get.opt.deep3 'from', 'spaFile', 'styles',  []
				dist:
					client: get.opt.deep3 'from', 'dist', 'client', []
					server: get.opt.deep3 'from', 'dist', 'server', []

	# format options
	# ==============
	formatFilesFrom = (opt, type) -> # prepend dist path to values then prepend '!'
		for appOrRb in ['app','rb']
			paths   = exclude[appOrRb].from[opt][type]
			forType = !!paths
			paths   = exclude[appOrRb].from[opt] unless forType
			continue unless paths.length
			paths  = (pathHelp.makeRelative _path for _path in paths)
			paths  = (path.join config.dist[appOrRb].client.dir, _path for _path in paths)
			negate = if opt is 'minFile' then '' else '!'
			paths  = ("#{negate}#{_path}" for _path in paths)
			# log.json paths
			if forType
				exclude[appOrRb].from[opt][type] = paths
			else
				exclude[appOrRb].from[opt] = paths

	formatFilesFrom 'cacheBust'
	formatFilesFrom 'minFile', 'scripts'
	formatFilesFrom 'minFile', 'styles'
	formatFilesFrom 'spaFile', 'scripts'
	formatFilesFrom 'spaFile', 'styles'

	# format exclude from dist
	# ========================
	getExcludeFromDirTypes = (appOrRb, loc) ->
		types = {}
		types[appOrRb] = {}
		types[appOrRb][loc] = {}
		for own k1, v1 of config.src[appOrRb][loc]
			continue if k1 is 'dir'
			types[appOrRb][loc][k1] = {}
			types[appOrRb][loc][k1].dir = v1.dir
		types

	getExcludeFromDistType = (types, appOrRb, loc, _path) ->
		type     = null
		allTypes = ['bower', 'images', 'libs']
		for own k1, v1 of types[appOrRb][loc]
			index = _path.indexOf(v1.dir)
			if index is 0
				ext  = path.extname _path
				lang = if ext and ext.indexOf('*') is -1 then ext.substr 1 else 'all'
				lang = 'sass' if lang is 'scss'
				lang = 'all' if allTypes.indexOf(k1) isnt -1
				type = { type: k1, lang, path: "!#{_path}" }
				break
		type

	getExcludeFromDist = (appOrRb, loc) -> # prepend src path to values then prepend '!'
		paths = exclude[appOrRb].from.dist[loc]
		return [] unless paths.length
		types   = getExcludeFromDirTypes appOrRb, loc
		srcPath = config.src[appOrRb][loc].dir
		paths   = (path.join srcPath, _path for _path in paths)
		eTypes  = {}
		for _path in paths
			type = getExcludeFromDistType types, appOrRb, loc, _path
			continue unless type
			eTypes[type.type] = {} unless eTypes[type.type]
			eTypes[type.type][type.lang] = [] unless eTypes[type.type][type.lang]
			eTypes[type.type][type.lang].push type.path
		return [] unless Object.keys(eTypes).length
		eTypes

	exclude.rb.from.dist.client  = getExcludeFromDist 'rb', 'client'
	exclude.rb.from.dist.server  = getExcludeFromDist 'rb', 'server'
	exclude.app.from.dist.client = getExcludeFromDist 'app', 'client'
	exclude.app.from.dist.server = getExcludeFromDist 'app', 'server'
	# log.json exclude.rb.from.dist,  'rb dist exclude ='
	# log.json exclude.app.from.dist, 'app dist exclude ='

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


