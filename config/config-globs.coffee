module.exports = (config) ->
	path     = require 'path'
	log      = require "#{config.req.helpers}/log"
	isType   = require "#{config.req.helpers}/isType"
	pathHelp = require "#{config.req.helpers}/path"
	test     = require("#{config.req.helpers}/test")()

	# exts
	# ====
	exts =
		coffee: 'coffee'
		css:    'css'
		es6:    'es6'
		fonts:  'eot,svg,ttf,woff,woff2' # not used
		html:   'html'
		images: 'gif,jpg,jpeg,png'
		js:     'js'
		less:   'less'
		sass:   'sass' # not used yet

	getExts = (_exts) -> # _exts = string array
		_exts = _exts.split ','
		_exts = (ext.trim() for ext in _exts)
		combined = ''
		total    = _exts.length - 1
		for ext, i in _exts
			combined += exts[ext]
			combined += ',' if i isnt total
		combined

	# langs
	# =====
	lang =
		all:       '/**'
		coffee:    "/**/*.#{exts.coffee}"
		css:       "/**/*.#{exts.css}"
		es6:       "/**/*.#{exts.es6}"
		html:      "/**/*.#{exts.html}"
		images:    "/**/*.{#{exts.images}}"
		js:        "/**/*.#{exts.js}"
		less:      "/**/*.#{exts.less}"
		sass:      "/**/*.#{exts.sass}"
		bustFiles: "/**/*.{#{getExts 'css,js,images'}}"
		bustRefs:  "/**/*.{#{getExts 'html,css,js'}}"

	# helpers
	# =======
	initGlob = ->
		['dist', 'src'].forEach (loc) ->
			glob[loc] = {}
			['rb', 'app'].forEach (v1) ->
				glob[loc][v1] = {}
				['client', 'server'].forEach (v2) ->
					glob[loc][v1][v2] = {}
					if v2 isnt 'server'
						glob[loc][v1][v2].all = "#{config[loc][v1][v2].dir}/**"

	addGlob = (loc, type, langs, includeBower, includeLibs) ->
		for own k1, v1 of glob[loc]
			for own k2, v2 of v1
				continue if k2 is 'server' and type isnt 'scripts'
				continue if k2 is 'server' and (includeBower or includeLibs)
				v2[type] = {} if not isType.object v2[type]
				langs.forEach (v3) ->
					typeDir = pathHelp.format config[loc][k1][k2][type].dir
					if includeBower or includeLibs
						bowerDir = pathHelp.format config[loc][k1][k2]['bower'].dir
						libsDir  = pathHelp.format config[loc][k1][k2]['libs'].dir
						v2[type][v3] = [
							path.join bowerDir, lang[v3]
							path.join libsDir,  lang[v3]
							path.join typeDir,  lang[v3]
						]
					else
						v2[type][v3] = path.join typeDir, lang[v3]

	# init glob
	# =========
	glob = {}
	initGlob()

	# src
	# ===
	addGlob 'src', 'images',  ['all']
	addGlob 'src', 'libs',    ['all']
	addGlob 'src', 'scripts', ['js']
	addGlob 'src', 'scripts', ['coffee']
	addGlob 'src', 'scripts', ['es6']
	addGlob 'src', 'styles',  ['css']
	addGlob 'src', 'styles',  ['less']
	# addGlob 'src', 'styles',  ['sass']
	addGlob 'src', 'views',   ['html']

	# dist
	# ====
	addGlob 'dist', 'bower',   ['all', 'css', 'js'] # css and js are for concat-scripts-and-styles task
	addGlob 'dist', 'images',  ['all']
	addGlob 'dist', 'libs',    ['all', 'css', 'js'] # css and js are for concat-scripts-and-styles task
	addGlob 'dist', 'scripts', ['all']
	addGlob 'dist', 'scripts', ['js' ], true, true
	addGlob 'dist', 'styles',  ['all']
	addGlob 'dist', 'styles',  ['css'], true, true
	addGlob 'dist', 'views',   ['all']
	addGlob 'dist', 'views',   ['html']

	# cache bust
	# ==========
	addCacheBust = (type, lang) ->
		_glob = path.join config.dist.app.client.dir, lang
		glob.dist.app.client.cacheBust[type] = [ _glob ]

	addCacheBustExcludes = ->
		glob.dist.app.client.cacheBust.files =
			[].concat(
				glob.dist.app.client.cacheBust.files
				config.exclude.rb.from.cacheBust
				config.exclude.app.from.cacheBust
			)

	glob.dist.app.client.cacheBust = {}
	addCacheBust 'files',      lang.bustFiles
	addCacheBust 'references', lang.bustRefs
	addCacheBustExcludes()

	# methods
	# =======
	removeAppAngularMocksDir = ->
		srcScripts  = glob.src.app.client.scripts
		noMocksGlob = "!#{config.angular.httpBackend.dir}#{lang.all}"
		for own k, v of srcScripts
			srcScripts[k] = [v, noMocksGlob]

	removeRbAngularMocks = -> # helper
		glob.dist.rb.client.scripts.js.splice 1, 1
		removeAppAngularMocksDir()

	glob.removeRbAngularMocks = ->
		if config.env.is.prod
			removeRbAngularMocks() if not config.angular.httpBackend.prod
		else if not config.angular.httpBackend.dev
			removeRbAngularMocks()

	# loading order for scripts and styles
	# ====================================
	addDistDir = (appOrRb, type, ext) ->
		for own k1, v1 of type
			v1.forEach (v, i) ->
				v1[i] = path.join config.dist[appOrRb].client.dir, v
				v1[i] += ".#{ext}"

	addFirst = (appOrRb, type, array, ext) ->
		return if not array.length
		array.slice().reverse().forEach (v) ->
			glob.dist[appOrRb].client[type][ext].unshift v

	addLast = (appOrRb, type, array, ext) ->
		return if not array.length
		array.forEach (v) ->
			glob.dist[appOrRb].client[type][ext].push "!#{v}", v

	order = ->
		for own k1, v1 of config.order
			for own k2, v2 of v1
				tot = config.order[k1][k2].first.length +
					  config.order[k1][k2].last.length
				continue if not tot
				ext = 'js'  if k2 is 'scripts'
				ext = 'css' if k2 is 'styles'
				addDistDir k1, v2, ext
				addFirst   k1, k2, v2.first, ext
				addLast    k1, k2, v2.last,  ext

	order()

	# node_modules
	# ============
	addNodeModule = (loc, module) ->
		glob.node_modules[loc][module] =
			path.join pathHelp.format(config.node_modules.src.modules[module]), lang.all

	glob.node_modules = {}
	glob.node_modules.dist = {}
	glob.node_modules.src  = {}
	addNodeModule 'src', 'express'
	addNodeModule 'src', 'q'

	# browser sync
	# ============
	glob.browserSync = path.join pathHelp.format(config.dist.app.client.dir), lang.all

	# add glob to config
	# ==================
	config.glob = glob

	# logs
	# ====
	# log.json glob, 'glob ='
	# log.json config, 'config ='

	# tests
	# =====
	test.log 'true', config.glob, 'add glob to config'

	# return
	# ======
	config


